import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network/network.dart';
import 'package:previously_searched/src/data/previously_searched_item.dart';
import 'package:previously_searched/src/data/previously_searched_repository.dart';
import 'package:previously_searched/src/data/previously_searched_response.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockCacheService extends Mock implements CacheService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late PreviouslySearchedRepository repository;
  late MockApiClient mockApi;
  late MockCacheService mockCacheService;
  late String mockApiData;

  setUp(() {
    mockApi = MockApiClient();
    mockCacheService = MockCacheService();
    repository = PreviouslySearchedRepository(
      apiClient: mockApi,
      cacheService: mockCacheService,
    );
  });

  group('PreviouslySearchedRepository Tests with data: ', () {
    setUp(() {
      mockApiData = '''
        {
          "data": [
            {
                "iconUrl": "assets/icons/products/dairy.jpg",
                "searchText": "milk",
                "type": "category",
                "slug": "",
                "productId": "",
                "categoryId": ""
            },
            {
                "iconUrl": "assets/icons/products/bath.jpg",
                "searchText": "shampoo",
                "type": "category",
                "slug": "",
                "productId": "",
                "categoryId": ""
            }
          ]
        }
      ''';
    });

    tearDown(() {});

    test(
      'loadPreviouslySearched should return list of PreviouslySearchedItem',
      () async {
        when(
          () => mockApi.get('previously_searched?phone_number=9980200445'),
        ).thenAnswer((_) async {
          return jsonDecode(mockApiData) as Map<String, dynamic>;
        });
        when(
          () => mockCacheService.write<List<PreviouslySearchedItem>>(
            key: any(named: 'key'),
            value: any(named: 'value'),
            ttlHrs: any(named: 'ttlHrs'),
            encode: any(named: 'encode'),
          ),
        ).thenAnswer((_) async {});

        final searchItems = await repository.loadPreviouslySearched();

        // Verify the result is a list of PreviouslySearchedItem
        expect(searchItems, isA<List<PreviouslySearchedItem>>());
        expect(searchItems.length, 2);

        expect(searchItems[0].searchText, 'milk');
        expect(searchItems[1].searchText, 'shampoo');
        expect(searchItems[0].iconUrl, 'assets/icons/products/dairy.jpg');
        expect(searchItems[1].iconUrl, 'assets/icons/products/bath.jpg');
        expect(searchItems[0].type, 'category');
        expect(searchItems[1].type, 'category');
      },
    );
  });

  group('SearchItemResponse Tests: ', () {
    late dynamic json;

    setUp(() {
      json = {
        'iconUrl': 'assets/icons/products/bath.jpg',
        'searchText': 'shampoo',
        'type': 'category',
        'slug': '',
        'productId': '',
        'categoryId': '',
      };
    });

    tearDown(() {});

    test('fromJson should return list of SearchItemResponse', () {
      final searchItemResponse = PreviouslySearchedResponse.fromJson(
        json as Map<String, dynamic>,
      );

      expect(searchItemResponse.searchText, 'shampoo');
      expect(searchItemResponse.type, 'category');
      expect(searchItemResponse.iconUrl, 'assets/icons/products/bath.jpg');
    });
  });

  group('Cache Tests: ', () {
    setUp(() {});

    tearDown(() {});

    test('should return cached data', () {
      // Create a pre-decoded result to return
      const expectedSection = PreviouslySearchedItem(
        searchText: 'shampoo',
        type: 'category',
        iconUrl: 'assets/icons/products/bath.jpg',
        productId: '',
        categoryId: '',
        slug: '',
      );

      final cacheEntry = CacheEntry<List<PreviouslySearchedItem>>(
        value: [expectedSection],
        expiry: DateTime.now().add(const Duration(hours: 1)),
      );

      // Simply mock the read method to return our pre-created cache entry
      when(
        () => mockCacheService.read<List<PreviouslySearchedItem>>(
          key: 'PreviouslySearched',
          decode: any(named: 'decode'),
        ),
      ).thenReturn(cacheEntry);

      // Act
      final result = repository.cachedPreviouslySearched;

      // Assert
      expect(result, isNotNull);
      expect(result!.value.length, equals(1));
      expect(result.value[0].searchText, equals('shampoo'));
      expect(result.value[0].iconUrl, equals('assets/icons/products/bath.jpg'));
      expect(result.value[0].type, equals('category'));

      // Verify the read method was called with the correct parameters
      verify(
        () => mockCacheService.read<List<PreviouslySearchedItem>>(
          key: 'PreviouslySearched',
          decode: any(named: 'decode'),
        ),
      ).called(1);
    });

    test('clearCache should delete cache entry', () async {
      when(() => mockCacheService.delete(any())).thenAnswer((_) async {});

      repository.clearCache();

      verify(() => mockCacheService.delete('PreviouslySearched')).called(1);
    });

    test('should correctly decode raw data from cache', () {
      final rawData = [
        {
          'searchText': 'shampoo',
          'iconUrl': 'assets/icons/products/bath.jpg',
          'type': 'category',
          'slug': '',
          'productId': '',
          'categoryId': '',
        },
      ];

      // Instead of trying to capture the decode function, let's verify it works correctly
      // by setting up the mock to return a properly decoded result
      when(
        () => mockCacheService.read<List<PreviouslySearchedItem>>(
          key: 'PreviouslySearched',
          decode: any(named: 'decode'),
        ),
      ).thenAnswer((invocation) {
        // Get the decode function from the invocation
        final decodeFunction =
            invocation.namedArguments[const Symbol('decode')]
                as List<PreviouslySearchedItem> Function(dynamic);

        // Use the actual decode function on our test data
        try {
          final decoded = decodeFunction(rawData);
          // Return a cache entry with the decoded data
          return CacheEntry<List<PreviouslySearchedItem>>(
            value: decoded,
            expiry: DateTime.now().add(const Duration(hours: 1)),
          );
        } catch (e) {
          fail('Decode function threw an exception: $e');
        }
      });

      // Act
      final result = repository.cachedPreviouslySearched;

      // Assert
      expect(result, isNotNull);
      expect(result!.value, isA<List<PreviouslySearchedItem>>());
      expect(result.value.length, equals(1));
      expect(result.value[0].searchText, equals('shampoo'));
      expect(result.value[0].iconUrl, equals('assets/icons/products/bath.jpg'));
      expect(result.value[0].type, equals('category'));
    });
  });
}
