import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:categories/categories.dart';
import 'package:categories/src/data/category_item.dart';
import 'package:categories/src/data/category_item_view_model.dart';
import 'package:categories/src/data/category_section.dart';
import 'package:categories/src/data/category_section_view_model.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoriesRepository extends Mock implements CategoriesRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CategoriesBloc Tests', () {
    late MockCategoriesRepository mockRepository;
    late CategoriesBloc categoriesBloc;
    late List<CategorySectionViewModel> mockCategoriesViewModels;
    late List<CategorySection> mockCategories;
    late CacheEntry<List<CategorySection>> mockCacheEntry;

    setUp(() {
      mockRepository = MockCategoriesRepository();
      categoriesBloc = CategoriesBloc(categoriesRepository: mockRepository);
      mockCategoriesViewModels = [
        CategorySectionViewModel(
          title: 'Grocery & Kitchen',
          sequence: 1,
          items: [
            CategoryItemViewModel(
              id: '1',
              name: 'Fruits & Vegetables',
              imageUrl: 'assets/images/categories/fruits.jpg',
              sequence: 1,
            ),
            CategoryItemViewModel(
              id: '2',
              name: 'Dairy, Bread & Eggs',
              imageUrl: 'assets/images/categories/dairy.jpg',
              sequence: 2,
            ),
          ],
        ),
        CategorySectionViewModel(
          title: 'Personal Care',
          sequence: 2,
          items: [
            CategoryItemViewModel(
              id: '1',
              name: 'Bath & Body',
              imageUrl: 'assets/images/categories/bath.jpg',
              sequence: 1,
            ),
          ],
        ),
      ];
      mockCategories = [
        CategorySection(
          title: 'Grocery & Kitchen',
          sequence: 1,
          items: [
            CategoryItem(
              id: '1',
              name: 'Fruits & Vegetables',
              imageUrl: 'assets/images/categories/fruits.jpg',
              sequence: 1,
            ),
            CategoryItem(
              id: '2',
              name: 'Dairy, Bread & Eggs',
              imageUrl: 'assets/images/categories/dairy.jpg',
              sequence: 2,
            ),
          ],
        ),
        CategorySection(
          title: 'Personal Care',
          sequence: 2,
          items: [
            CategoryItem(
              id: '1',
              name: 'Bath & Body',
              imageUrl: 'assets/images/categories/bath.jpg',
              sequence: 1,
            ),
          ],
        ),
      ];
      final expiry = DateTime.now().add(const Duration(hours: 1));
      mockCacheEntry = CacheEntry(value: mockCategories, expiry: expiry);
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
        return categoriesBloc;
      },
      act: (bloc) => bloc.add(FetchCategories()),
      expect: () => [isA<CategoriesLoading>(), isA<CategoriesLoaded>()],
    );

    blocTest<CategoriesBloc, CategoriesState>(
      'FetchCategories transforms categories to view models',
      build: () {
        when(
          mockRepository.loadCategories,
        ).thenAnswer((_) async => mockCategories);
        when(() => mockRepository.cachedCategories).thenReturn(null);
        return categoriesBloc;
      },
      act: (bloc) => bloc.add(FetchCategories()),
      expect: () => [isA<CategoriesLoading>(), isA<CategoriesLoaded>()],
      verify: (bloc) {
        final state = bloc.state as CategoriesLoaded;
        expect(
          state.categories[0].title,
          equals(mockCategoriesViewModels[0].title),
        );
        expect(
          state.categories[1].title,
          equals(mockCategoriesViewModels[1].title),
        );
        expect(
          state.categories[0].items[0].name,
          equals(mockCategoriesViewModels[0].items[0].name),
        );
        expect(
          state.categories[1].items[0].name,
          equals(mockCategoriesViewModels[1].items[0].name),
        );
      },
    );

    blocTest<CategoriesBloc, CategoriesState>(
      'emits [CategoriesLoading, CategoriesFailedLoading] when repository fails to load',
      build: () {
        when(
          mockRepository.loadCategories,
        ).thenThrow(Exception('Failed to load categories'));
        when(() => mockRepository.cachedCategories).thenReturn(null);
        return categoriesBloc;
      },
      act: (bloc) => bloc.add(FetchCategories()),
      expect: () => [CategoriesLoading(), const CategoriesFailedLoading()],
    );

    blocTest<CategoriesBloc, CategoriesState>(
      'emits [CategoriesLoading, CategoriesFailedLoading] when repository fails to load',
      build: () {
        final expiry = DateTime.now().subtract(const Duration(hours: 5));
        final expiredCache = CacheEntry(value: mockCategories, expiry: expiry);
        when(
          mockRepository.loadCategories,
        ).thenThrow(Exception('Failed to load categories'));
        when(() => mockRepository.cachedCategories).thenReturn(expiredCache);
        return categoriesBloc;
      },
      act: (bloc) => bloc.add(FetchCategories()),
      expect: () => [isA<CategoriesLoading>(), isA<CategoriesFailedLoading>()],
    );

    blocTest<CategoriesBloc, CategoriesState>(
      'emits [CategoriesLoading, CategoriesLoaded] when categories are empty',
      build: () {
        when(mockRepository.loadCategories).thenAnswer((_) async => []);
        when(() => mockRepository.cachedCategories).thenReturn(null);
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
        when(() => mockRepository.cachedCategories).thenReturn(mockCacheEntry);
        return categoriesBloc;
      },
      act: (bloc) => bloc.add(FetchCategories()),
      expect: () => [isA<CategoriesLoaded>()],
    );

    blocTest<CategoriesBloc, CategoriesState>(
      'emits [CategoriesLoading, CategoriesOffline] when offline and no cache',
      build: () {
        when(
          mockRepository.loadCategories,
        ).thenThrow(const SocketException('No Internet'));
        when(() => mockRepository.cachedCategories).thenReturn(null);
        return categoriesBloc;
      },
      act: (bloc) => bloc.add(FetchCategories()),
      expect: () => [CategoriesLoading(), const CategoriesOffline()],
    );

    blocTest<CategoriesBloc, CategoriesState>(
      'emits [CategoriesLoading, CategoriesOffline] when offline with expired cache',
      build: () {
        final expiry = DateTime.now().subtract(const Duration(hours: 4));
        final expiredCache = CacheEntry(value: mockCategories, expiry: expiry);
        when(
          mockRepository.loadCategories,
        ).thenThrow(const SocketException('No Internet'));
        when(() => mockRepository.cachedCategories).thenReturn(expiredCache);
        return categoriesBloc;
      },
      act: (bloc) => bloc.add(FetchCategories()),
      expect: () => [isA<CategoriesLoading>(), isA<CategoriesOffline>()],
    );
  });
}
