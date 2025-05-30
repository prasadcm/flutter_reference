import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:categories/categories.dart';
import 'package:categories/src/data/category_item.dart';
import 'package:categories/src/data/category_section.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoriesRepository extends Mock implements CategoriesRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CategoriesBloc Tests', () {
    late MockCategoriesRepository mockRepository;
    late CategoriesBloc categoriesBloc;
    late List<CategorySection> mockCategories;

    setUp(() {
      mockRepository = MockCategoriesRepository();
      categoriesBloc = CategoriesBloc(categoriesRepository: mockRepository);
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
      categoriesBloc.close();
    });

    blocTest<CategoriesBloc, CategoriesState>(
      'emits [CategoriesLoading,CategoriesLoaded] when FetchCategories is triggered',
      build: () {
        when(
          mockRepository.loadCategories,
        ).thenAnswer((_) async => mockCategories);
        when(() => mockRepository.cachedCategories).thenReturn(null);
        when(() => mockRepository.isCacheValid).thenReturn(false);
        return categoriesBloc;
      },
      act: (bloc) => bloc.add(FetchCategories()),
      expect:
          () => [
            CategoriesLoading(),
            CategoriesLoaded(categories: mockCategories),
          ],
    );

    blocTest<CategoriesBloc, CategoriesState>(
      'emits [CategoriesLoading, CategoriesFailedLoading] when repository fails to load',
      build: () {
        when(
          mockRepository.loadCategories,
        ).thenThrow(Exception('Failed to load categories'));
        when(() => mockRepository.cachedCategories).thenReturn(null);
        when(() => mockRepository.isCacheValid).thenReturn(false);
        return categoriesBloc;
      },
      act: (bloc) => bloc.add(FetchCategories()),
      expect: () => [CategoriesLoading(), const CategoriesFailedLoading()],
    );

    blocTest<CategoriesBloc, CategoriesState>(
      'emits [CategoriesLoading, CategoriesFailedLoading] when repository fails to load but expired cache exists',
      build: () {
        when(
          mockRepository.loadCategories,
        ).thenThrow(Exception('Failed to load categories'));
        when(() => mockRepository.cachedCategories).thenReturn(mockCategories);
        when(() => mockRepository.isCacheValid).thenReturn(false);
        return categoriesBloc;
      },
      act: (bloc) => bloc.add(FetchCategories()),
      expect:
          () => [
            CategoriesLoading(),
            CategoriesFailedLoading(cachedCategories: mockCategories),
          ],
    );

    blocTest<CategoriesBloc, CategoriesState>(
      'emits [CategoriesLoading, CategoriesLoaded] when categories are empty',
      build: () {
        when(mockRepository.loadCategories).thenAnswer((_) async => []);
        when(() => mockRepository.cachedCategories).thenReturn(null);
        when(() => mockRepository.isCacheValid).thenReturn(false);
        return categoriesBloc;
      },
      act: (bloc) => bloc.add(FetchCategories()),
      expect:
          () => [CategoriesLoading(), const CategoriesLoaded(categories: [])],
    );

    blocTest<CategoriesBloc, CategoriesState>(
      'emits [CategoriesLoaded] when cache exists and valid',
      build: () {
        when(
          mockRepository.loadCategories,
        ).thenAnswer((_) async => mockCategories);
        when(() => mockRepository.cachedCategories).thenReturn(mockCategories);
        when(() => mockRepository.isCacheValid).thenReturn(true);
        return categoriesBloc;
      },
      act: (bloc) => bloc.add(FetchCategories()),
      expect: () => [CategoriesLoaded(categories: mockCategories)],
    );

    blocTest<CategoriesBloc, CategoriesState>(
      'emits [CategoriesLoading, CategoriesOffline] when offline and no cache',
      build: () {
        when(
          mockRepository.loadCategories,
        ).thenThrow(const SocketException('No Internet'));
        when(() => mockRepository.cachedCategories).thenReturn(null);
        when(() => mockRepository.isCacheValid).thenReturn(false);
        return categoriesBloc;
      },
      act: (bloc) => bloc.add(FetchCategories()),
      expect: () => [CategoriesLoading(), const CategoriesOffline()],
    );

    blocTest<CategoriesBloc, CategoriesState>(
      'emits [CategoriesLoading, CategoriesOffline] when offline with expired cache',
      build: () {
        when(
          mockRepository.loadCategories,
        ).thenThrow(const SocketException('No Internet'));
        when(() => mockRepository.cachedCategories).thenReturn(mockCategories);
        when(() => mockRepository.isCacheValid).thenReturn(false);
        return categoriesBloc;
      },
      act: (bloc) => bloc.add(FetchCategories()),
      expect:
          () => [
            CategoriesLoading(),
            CategoriesOffline(cachedCategories: mockCategories),
          ],
    );
  });
}
