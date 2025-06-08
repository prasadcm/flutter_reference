import 'dart:convert';

import 'package:categories/categories.dart';
import 'package:categories/src/data/category_item.dart';
import 'package:categories/src/data/category_section.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network/network.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockCacheService extends Mock implements CacheService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late CategoriesRepository repository;
  late MockApiClient mockApi;
  late MockCacheService mockCacheService;
  late String mockApiData;

  setUp(() {
    mockApi = MockApiClient();
    mockCacheService = MockCacheService();
    repository = CategoriesRepository(
      apiClient: mockApi,
      cacheService: mockCacheService,
    );
  });

  group('CategoriesRepository Tests with data: ', () {
    setUp(() {
      mockApiData = '''
        {
          "data" : [
            {
              "category_id": "1",
              "item_id": "1",
              "name": "Grocery & Kitchen",
              "item": "Fruits & Vegetables",
              "image": "assets/images/categories/fruits.jpg",
              "category_sequence": 1,
              "item_sequence": 1
            },
            {
              "category_id": "1",
              "item_id": "2",
              "name": "Grocery & Kitchen",
              "item": "Dairy, Bread & Eggs",
              "image": "assets/images/categories/dairy.jpg",
              "category_sequence": 1,
              "item_sequence": 2
            }
          ]
        }
        ''';
    });

    tearDown(() {});

    test('loadCategories should return list of CategorySection', () async {
      when(() => mockApi.get('categories')).thenAnswer((_) async {
        return jsonDecode(mockApiData) as Map<String, dynamic>;
      });
      when(
        () => mockCacheService.write<List<CategorySection>>(
          key: any(named: 'key'),
          value: any(named: 'value'),
          ttlHrs: any(named: 'ttlHrs'),
          encode: any(named: 'encode'),
        ),
      ).thenAnswer((_) async {});

      final categories = await repository.loadCategories();

      // Verify the result is a list of CategorySection
      expect(categories, isA<List<CategorySection>>());
      expect(categories.length, 1);

      // Verify the first section
      expect(categories[0].title, 'Grocery & Kitchen');
      expect(categories[0].items[0], isA<CategoryItem>());
      expect(categories[0].items[1], isA<CategoryItem>());
      expect(categories[0].items[0].name, 'Fruits & Vegetables');
      expect(
        categories[0].items[0].imageUrl,
        'assets/images/categories/fruits.jpg',
      );
      expect(categories[0].items[1].name, 'Dairy, Bread & Eggs');
      expect(
        categories[0].items[1].imageUrl,
        'assets/images/categories/dairy.jpg',
      );
    });
  });

  group('CategoryResponse Tests: ', () {
    late dynamic json;

    setUp(() {
      json = {
        'category_id': '1',
        'item_id': '1',
        'name': 'Grocery & Kitchen',
        'item': 'Fruits & Vegetables',
        'image': 'assets/images/categories/fruits.jpg',
        'category_sequence': 1,
        'item_sequence': 1,
      };
    });

    tearDown(() {});

    test('fromJson should return list of CategoryResponse', () {
      final categoryResponse = CategoryResponse.fromJson(
        json as Map<String, dynamic>,
      );

      expect(categoryResponse.itemId, '1');
      expect(categoryResponse.categoryId, '1');
      expect(categoryResponse.name, 'Grocery & Kitchen');
      expect(categoryResponse.item, 'Fruits & Vegetables');
      expect(categoryResponse.image, 'assets/images/categories/fruits.jpg');
      expect(categoryResponse.categorySequence, 1);
      expect(categoryResponse.itemSequence, 1);
    });
  });

  group('Cache Tests: ', () {
    setUp(() {});

    tearDown(() {});

    test('should return cached data', () {
      // Create a pre-decoded result to return
      final expectedSection = CategorySection(
        title: 'Test Category',
        sequence: 1,
        items: [
          CategoryItem(
            id: '1',
            name: 'Test Item',
            imageUrl: 'test.jpg',
            sequence: 1,
          ),
        ],
      );

      final cacheEntry = CacheEntry<List<CategorySection>>(
        value: [expectedSection],
        expiry: DateTime.now().add(const Duration(hours: 1)),
      );

      // Simply mock the read method to return our pre-created cache entry
      when(
        () => mockCacheService.read<List<CategorySection>>(
          key: 'Categories',
          decode: any(named: 'decode'),
        ),
      ).thenReturn(cacheEntry);

      // Act
      final result = repository.cachedCategories;

      // Assert
      expect(result, isNotNull);
      expect(result!.value.length, equals(1));
      expect(result.value[0].title, equals('Test Category'));
      expect(result.value[0].items.length, equals(1));
      expect(result.value[0].items[0].name, equals('Test Item'));

      // Verify the read method was called with the correct parameters
      verify(
        () => mockCacheService.read<List<CategorySection>>(
          key: 'Categories',
          decode: any(named: 'decode'),
        ),
      ).called(1);
    });

    test('clearCache should delete cache entry', () async {
      when(() => mockCacheService.delete(any())).thenAnswer((_) async {});

      repository.clearCache();

      verify(() => mockCacheService.delete('Categories')).called(1);
    });

    test('should correctly decode raw data from cache', () {
      final rawData = [
        {
          'title': 'Test Category',
          'sequence': 1,
          'items': [
            {
              'id': '1',
              'name': 'Test Item',
              'imageUrl': 'test.jpg',
              'sequence': 1,
            },
          ],
        },
      ];

      // Instead of trying to capture the decode function, let's verify it works correctly
      // by setting up the mock to return a properly decoded result
      when(
        () => mockCacheService.read<List<CategorySection>>(
          key: 'Categories',
          decode: any(named: 'decode'),
        ),
      ).thenAnswer((invocation) {
        // Get the decode function from the invocation
        final decodeFunction =
            invocation.namedArguments[const Symbol('decode')]
                as List<CategorySection> Function(dynamic);

        // Use the actual decode function on our test data
        try {
          final decoded = decodeFunction(rawData);
          // Return a cache entry with the decoded data
          return CacheEntry<List<CategorySection>>(
            value: decoded,
            expiry: DateTime.now().add(const Duration(hours: 1)),
          );
        } catch (e) {
          fail('Decode function threw an exception: $e');
        }
      });

      // Act
      final result = repository.cachedCategories;

      // Assert
      expect(result, isNotNull);
      expect(result!.value, isA<List<CategorySection>>());
      expect(result.value.length, equals(1));
      expect(result.value[0].title, equals('Test Category'));
      expect(result.value[0].items.length, equals(1));
      expect(result.value[0].items[0].name, equals('Test Item'));
    });
  });
}
