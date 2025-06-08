import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network/network.dart';
import 'package:previously_searched/src/data/previously_searched_item.dart';
import 'package:previously_searched/src/data/previously_searched_repository.dart';
import 'package:previously_searched/src/data/search_item_response.dart';

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
          "total": 2,
          "data": {
            "results" : [
              {
                "product": "product1",
                "productIcon": "icon1",
                "productUrl": "url1",
                "searchCount": 1
              },
              {
                "product": "product2",
                "productIcon": "icon2",
                "productUrl": "url2",
                "searchCount": 2
              }
            ]
          }
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

        expect(searchItems[0].product, 'product1');
        expect(searchItems[1].product, 'product2');
        expect(searchItems[0].productIcon, 'icon1');
        expect(searchItems[1].productIcon, 'icon2');
        expect(searchItems[0].productUrl, 'url1');
        expect(searchItems[1].productUrl, 'url2');
      },
    );
  });

  group('SearchItemResponse Tests: ', () {
    late dynamic json;

    setUp(() {
      json = {
        'product': 'product1',
        'productIcon': 'icon1',
        'productUrl': 'url1',
        'searchCount': 1,
      };
    });

    tearDown(() {});

    test('fromJson should return list of SearchItemResponse', () {
      final searchItemResponse = SearchItemResponse.fromJson(
        json as Map<String, dynamic>,
      );

      expect(searchItemResponse.product, 'product1');
      expect(searchItemResponse.productIcon, 'icon1');
      expect(searchItemResponse.productUrl, 'url1');
    });
  });

  group('Cache Tests: ', () {
    setUp(() {});

    tearDown(() {});

    test('should return cached data', () {
      // Create a pre-decoded result to return
      const expectedSection = PreviouslySearchedItem(
        product: 'product1',
        productIcon: 'icon1',
        productUrl: 'url1',
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
      expect(result.value[0].product, equals('product1'));
      expect(result.value[0].productIcon, equals('icon1'));
      expect(result.value[0].productUrl, equals('url1'));

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
        {'product': 'product1', 'productIcon': 'icon1', 'productUrl': 'url1'},
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
      expect(result.value[0].product, equals('product1'));
      expect(result.value[0].productIcon, equals('icon1'));
      expect(result.value[0].productUrl, equals('url1'));
    });
  });
}
