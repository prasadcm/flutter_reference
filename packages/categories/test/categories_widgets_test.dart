import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:categories/categories.dart';
import 'package:categories/src/data/category_item.dart';
import 'package:categories/src/data/category_section.dart';
import 'package:categories/src/presentation/category_item_widget.dart';
import 'package:categories/src/presentation/category_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ui_components/ui_components.dart';

class MockCategoriesBloc extends MockBloc<CategoriesEvent, CategoriesState>
    implements CategoriesBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CategoryItemWidget Widget Tests', () {
    late CategoryItem item;

    setUp(() {
      item = CategoryItem(
        id: '1',
        name: 'Fruits & Vegetables',
        imageUrl: 'assets/images/categories/fruits.jpg',
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

      final decoration = containerWithDecoration.decoration! as BoxDecoration;
      expect(decoration.image, isNotNull);
      expect(decoration.image!.image, isA<AssetImage>());
    });
  });

  group('CategorySectionWidget Tests', () {
    late CategorySection section;

    setUp(() {
      section = CategorySection(
        title: 'Fruits & Vegetables',
        items: [
          CategoryItem(
            id: '1',
            name: 'Fruits',
            imageUrl: 'assets/images/categories/fruits.jpg',
          ),
          CategoryItem(
            id: '2',
            name: 'Vegetables',
            imageUrl: 'assets/images/categories/fruits.jpg',
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
    late List<CategorySection> mockCategories;
    late MockCategoriesBloc mockCategoriesBloc;
    final getIt = GetIt.instance;

    setUp(() {
      mockCategoriesBloc = MockCategoriesBloc();
      getIt.registerFactory<CategoriesBloc>(() => mockCategoriesBloc);

      mockCategories = [
        CategorySection(
          title: 'Grocery & Kitchen',
          items: [
            CategoryItem(
              id: '1',
              name: 'Fruits & Vegetables',
              imageUrl: 'assets/images/categories/fruits.jpg',
            ),
            CategoryItem(
              id: '2',
              name: 'Dairy, Bread & Eggs',
              imageUrl: 'assets/images/categories/dairy.jpg',
            ),
          ],
        ),
        CategorySection(
          title: 'Personal Care',
          items: [
            CategoryItem(
              id: '1',
              name: 'Bath & Body',
              imageUrl: 'assets/images/categories/bath.jpg',
            ),
          ],
        ),
      ];
    });

    tearDown(() {
      getIt.reset();
    });

    testWidgets('renders correctly with categories', (
      WidgetTester tester,
    ) async {
      when(() => mockCategoriesBloc.state).thenReturn(CategoriesInitial());

      final stateController = StreamController<CategoriesState>();

      whenListen(
        mockCategoriesBloc,
        stateController.stream,
        initialState: CategoriesInitial(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<CategoriesBloc>.value(
            value: mockCategoriesBloc,
            child: const Scaffold(body: CategoryView()),
          ),
        ),
      );

      expect(find.byType(InitialView), findsOneWidget);

      stateController.add(CategoriesLoading());
      await tester.pump();

      expect(find.byType(LoadingView), findsOneWidget);
      expect(find.byType(InitialView), findsNothing);

      stateController.add(CategoriesLoaded(categories: mockCategories));
      await tester.pump();

      // Verify the sections are created
      expect(find.byType(CategorySectionWidget), findsExactly(2));
      // Verify categories are displayed
      expect(find.byType(CategoryItemWidget), findsExactly(3));
      expect(find.byType(LoadingView), findsNothing);
    });

    testWidgets('renders error view', (WidgetTester tester) async {
      when(() => mockCategoriesBloc.state).thenReturn(CategoriesInitial());

      final stateController = StreamController<CategoriesState>();

      whenListen(
        mockCategoriesBloc,
        stateController.stream,
        initialState: CategoriesInitial(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<CategoriesBloc>.value(
            value: mockCategoriesBloc,
            child: const Scaffold(body: CategoryView()),
          ),
        ),
      );

      expect(find.byType(InitialView), findsOneWidget);

      stateController.add(CategoriesLoading());
      await tester.pump();

      expect(find.byType(LoadingView), findsOneWidget);
      expect(find.byType(InitialView), findsNothing);

      stateController.add(const CategoriesFailedLoading());
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.byType(ErrorView), findsOneWidget);
      expect(find.byType(LoadingView), findsNothing);

      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      // Verify the snackbar is dismissed
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('renders cached data with error toast', (
      WidgetTester tester,
    ) async {
      when(() => mockCategoriesBloc.state).thenReturn(CategoriesInitial());
      final stateController = StreamController<CategoriesState>();

      whenListen(
        mockCategoriesBloc,
        stateController.stream,
        initialState: CategoriesInitial(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<CategoriesBloc>.value(
            value: mockCategoriesBloc,
            child: const Scaffold(body: CategoryView()),
          ),
        ),
      );

      expect(find.byType(InitialView), findsOneWidget);

      stateController.add(CategoriesLoading());
      await tester.pump();

      expect(find.byType(LoadingView), findsOneWidget);
      expect(find.byType(InitialView), findsNothing);

      stateController.add(
        CategoriesFailedLoading(cachedCategories: mockCategories),
      );
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.byType(CategorySectionWidget), findsExactly(2));
      expect(find.byType(CategoryItemWidget), findsExactly(3));
      expect(find.byType(LoadingView), findsNothing);

      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      // Verify the snackbar is dismissed
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('renders offline view', (WidgetTester tester) async {
      when(() => mockCategoriesBloc.state).thenReturn(CategoriesInitial());
      final stateController = StreamController<CategoriesState>();

      whenListen(
        mockCategoriesBloc,
        stateController.stream,
        initialState: CategoriesInitial(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<CategoriesBloc>.value(
            value: mockCategoriesBloc,
            child: const Scaffold(body: CategoryView()),
          ),
        ),
      );

      expect(find.byType(InitialView), findsOneWidget);

      stateController.add(CategoriesLoading());
      await tester.pump();

      expect(find.byType(LoadingView), findsOneWidget);
      expect(find.byType(InitialView), findsNothing);

      stateController.add(const CategoriesOffline());
      await tester.pumpAndSettle();

      expect(find.byType(OfflineView), findsOneWidget);
      expect(find.byType(LoadingView), findsNothing);
    });

    testWidgets('renders cached data in offline', (WidgetTester tester) async {
      when(() => mockCategoriesBloc.state).thenReturn(CategoriesInitial());
      final stateController = StreamController<CategoriesState>();

      whenListen(
        mockCategoriesBloc,
        stateController.stream,
        initialState: CategoriesInitial(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<CategoriesBloc>.value(
            value: mockCategoriesBloc,
            child: const Scaffold(body: CategoryView()),
          ),
        ),
      );

      expect(find.byType(InitialView), findsOneWidget);

      stateController.add(CategoriesLoading());
      await tester.pump();

      expect(find.byType(LoadingView), findsOneWidget);
      expect(find.byType(InitialView), findsNothing);

      stateController.add(CategoriesOffline(cachedCategories: mockCategories));
      await tester.pumpAndSettle();

      expect(find.byType(CategorySectionWidget), findsExactly(2));
      expect(find.byType(CategoryItemWidget), findsExactly(3));
      expect(find.byType(OfflineBar), findsOneWidget);

      expect(find.byType(LoadingView), findsNothing);
    });
  });
}
