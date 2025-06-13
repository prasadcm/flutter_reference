import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network/network.dart';
import 'package:search_recommendation/search_recommendation.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockCacheService extends Mock implements CacheService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SearchRecommendationRepository Tests with data: ', () {
    late SearchRecommendationRepository repository;
    late MockApiClient mockApi;
    late String mockApiData;
    late MockCacheService mockCacheService;

    setUp(() {
      mockApi = MockApiClient();
      mockApiData = '''
        {
          "data" : [
            {
              "name": "Fruits"
            },
            {
              "name": "Vegetables"
            }
          ]
        }
        ''';
      mockCacheService = MockCacheService();

      repository = SearchRecommendationRepository(
        apiClient: mockApi,
        cacheService: mockCacheService,
      );
    });

    tearDown(() {});

    test('loadSearchRecommendation should return list of SearchRecommendation',
        () async {
      when(() => mockApi.get('search_recommendation')).thenAnswer((_) async {
        return jsonDecode(mockApiData) as Map<String, dynamic>;
      });
      when(
        () => mockCacheService.write<List<SearchRecommendationModel>>(
          key: any(named: 'key'),
          value: any(named: 'value'),
          ttlHrs: any(named: 'ttlHrs'),
          encode: any(named: 'encode'),
        ),
      ).thenAnswer((_) async {});
      final recommendations = await repository.loadSearchRecommendation();

      expect(recommendations, isA<List<SearchRecommendationModel>>());
      expect(recommendations.length, 2);

      expect(recommendations[0].name, 'Fruits');
      expect(recommendations[1].name, 'Vegetables');
    });
  });

  group('SearchRecommendationModel Tests: ', () {
    late dynamic json;

    setUp(() {
      json = {
        'name': 'Apple',
      };
    });

    tearDown(() {});

    test('fromJson should return list of SearchRecommendationModel', () {
      final recommendationModel = SearchRecommendationModel.fromJson(
        json as Map<String, dynamic>,
      );

      expect(recommendationModel.name, 'Apple');
    });
  });
}
