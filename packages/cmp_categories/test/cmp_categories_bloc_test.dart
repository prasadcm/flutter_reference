import 'package:bloc_test/bloc_test.dart';
import 'package:cmp_categories/cmp_categories.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'cmp_categories_bloc_test.mocks.dart';

@GenerateMocks([CategoriesRepository])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CategoriesBloc Tests', () {
    late MockCategoriesRepository mockRepository;
    late CategoriesBloc categoriesBloc;
    late List<CategoryModel> mockCategories;

    setUp(() {
      mockRepository = MockCategoriesRepository();
      categoriesBloc = CategoriesBloc(categoriesRepository: mockRepository);
      mockCategories = [
        CategoryModel(
          "1",
          "Grocery & Kitchen",
          1,
          "assets/images/categories/fruits.jpg",
          "Fruits & Vegetables",
          "1",
          1,
        ),
        CategoryModel(
          "1",
          "Grocery & Kitchen",
          1,
          "assets/images/categories/dairy.jpg",
          "Dairy, Bread & Eggs",
          "2",
          2,
        ),
        CategoryModel(
          "2",
          "Personal Care",
          2,
          "assets/images/categories/bath.jpg",
          "Bath & Body",
          "3",
          1,
        ),
      ];
    });

    tearDown(() {
      categoriesBloc.close();
    });

    blocTest<CategoriesBloc, CategoriesState>(
      'emits [CategoriesLoading, CategoriesLoaded] when FetchCategories is triggered',
      build: () {
        when(
          mockRepository.loadCategories(),
        ).thenAnswer((_) async => mockCategories);
        return categoriesBloc;
      },
      act: (bloc) => bloc.add(FetchCategories()),
      expect: () => [CategoriesLoading(), isA<CategoriesLoaded>()],
    );

    blocTest<CategoriesBloc, CategoriesState>(
      'emits [CategoriesLoading, CategoriesFailedLoading] when repository fails to load',
      build: () {
        when(
          mockRepository.loadCategories(),
        ).thenThrow(Exception('Failed to load categories'));
        return categoriesBloc;
      },
      act: (bloc) => bloc.add(FetchCategories()),
      expect: () => [CategoriesLoading(), CategoriesFailedLoading()],
    );

    blocTest<CategoriesBloc, CategoriesState>(
      'emits [CategoriesLoading, CategoriesLoaded] when categories are empty',
      build: () {
        when(mockRepository.loadCategories()).thenAnswer((_) async => []);
        return categoriesBloc;
      },
      act: (bloc) => bloc.add(FetchCategories()),
      expect: () => [CategoriesLoading(), CategoriesLoaded([])],
    );
  });
}
