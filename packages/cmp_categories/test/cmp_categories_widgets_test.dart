import 'package:cmp_categories/src/bloc/categories_bloc.dart';
import 'package:cmp_categories/src/data/categories_repository.dart';
import 'package:cmp_categories/src/data/category_item.dart';
import 'package:cmp_categories/src/data/category_model.dart';
import 'package:cmp_categories/src/data/category_section.dart';
import 'package:cmp_categories/src/widgets/categories_view.dart';
import 'package:cmp_categories/src/widgets/category_item_widget.dart';
import 'package:cmp_categories/src/widgets/category_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'cmp_categories_widgets_test.mocks.dart';

@GenerateMocks([CategoriesRepository])
void main() {
  Future<void> waitForDelay(WidgetTester tester, Duration duration) async {
    await tester.runAsync(() async {
      await Future.delayed(duration);
    });
  }

  TestWidgetsFlutterBinding.ensureInitialized();

  group('CategoryItemWidget Widget Tests', () {
    late CategoryItem item;

    setUp(() {
      item = CategoryItem(
        id: "1",
        name: "Fruits & Vegetables",
        imageUrl: "assets/images/categories/fruits.jpg",
      );
    });

    tearDown(() {});

    Widget createWidgetUnderTest() {
      return MaterialApp(home: Scaffold(body: CategoryItemWidget(item: item)));
    }

    testWidgets('renders CategoryItemWidget correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Verify the widget renders
      expect(find.byType(CategoryItemWidget), findsOneWidget);

      // Verify the item name is displayed
      expect(find.text('Fruits & Vegetables'), findsOneWidget);

      final containers = tester.widgetList<Container>(find.byType(Container));
      final containerWithDecoration = containers.firstWhere(
        (container) => container.decoration != null,
        orElse: () => throw Exception('No container with decoration found'),
      );

      final BoxDecoration decoration =
          containerWithDecoration.decoration as BoxDecoration;
      expect(decoration.image, isNotNull);
      expect(decoration.image!.image, isA<AssetImage>());
    });
  });

  group('CategorySectionWidget Tests', () {
    late CategorySection section;

    setUp(() {
      section = CategorySection(
        title: "Fruits & Vegetables",
        items: [
          CategoryItem(
            id: "1",
            name: "Fruits",
            imageUrl: "assets/images/categories/fruits.jpg",
          ),
          CategoryItem(
            id: "2",
            name: "Vegetables",
            imageUrl: "assets/images/categories/fruits.jpg",
          ),
        ],
      );
    });

    testWidgets('renders correctly with title and categories', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CategorySectionWidget(section: section)),
        ),
      );

      // Verify the title is displayed
      expect(find.text('Fruits & Vegetables'), findsOneWidget);

      // Verify categories are displayed
      expect(find.byType(CategoryItemWidget), findsExactly(2));
    });
  });

  group('CategoryView Tests', () {
    late List<CategoryModel> categorySections;
    late MockCategoriesRepository mockRepository;
    late CategoriesBloc categoriesBloc;

    setUp(() {
      mockRepository = MockCategoriesRepository();
      categoriesBloc = CategoriesBloc(categoriesRepository: mockRepository);

      categorySections = [
        CategoryModel(
          "1",
          "Category 1",
          1,
          "assets/images/categories/fruits.jpg",
          "item 1",
          "1",
          1,
        ),
        CategoryModel(
          "1",
          "Category 1",
          1,
          "assets/images/categories/fruits.jpg",
          "item 2",
          "2",
          1,
        ),
        CategoryModel(
          "1",
          "Category 2",
          2,
          "assets/images/categories/fruits.jpg",
          "item 3",
          "3",
          1,
        ),
      ];
    });

    tearDown(() {
      categoriesBloc.close();
    });

    testWidgets('renders correctly with categories', (
      WidgetTester tester,
    ) async {
      when(mockRepository.loadCategories()).thenAnswer((_) async {
        return categorySections;
      });

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<CategoriesBloc>.value(
            value: categoriesBloc,
            child: Scaffold(body: CategoryView()),
          ),
        ),
      );

      categoriesBloc.add(FetchCategories());
      await tester.pumpAndSettle();

      verify(mockRepository.loadCategories()).called(1);

      await waitForDelay(tester, const Duration(milliseconds: 0));

      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      // Verify the sections are created
      expect(find.byType(CategorySectionWidget), findsExactly(2));

      // Verify categories are displayed
      expect(find.byType(CategoryItemWidget), findsExactly(3));
    });
  });
}
