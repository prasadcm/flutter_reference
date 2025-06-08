import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network/network.dart';
import 'package:suggestions/suggestions.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockCacheService extends Mock implements CacheService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SuggestionsRepository Tests with data: ', () {
    late SuggestionsRepository repository;
    late MockApiClient mockApi;
    late String mockApiData;
    late MockCacheService mockCacheService;

    setUp(() {
      mockApi = MockApiClient();
      mockApiData = '''
        {
          "data" : [
            {
              "id": "1",
              "name": "Fruits"
            },
            {
              "id": "2",
              "name": "Vegetables"
            }
          ]
        }
        ''';
      mockCacheService = MockCacheService();

      repository = SuggestionsRepository(
        apiClient: mockApi,
        cacheService: mockCacheService,
      );
    });

    tearDown(() {});

    test('loadSuggestions should return list of Suggestions', () async {
      when(() => mockApi.get('suggestions')).thenAnswer((_) async {
        return jsonDecode(mockApiData) as Map<String, dynamic>;
      });
      when(
        () => mockCacheService.write<List<SuggestionModel>>(
          key: any(named: 'key'),
          value: any(named: 'value'),
          ttlHrs: any(named: 'ttlHrs'),
          encode: any(named: 'encode'),
        ),
      ).thenAnswer((_) async {});
      final suggestions = await repository.loadSuggestions();

      expect(suggestions, isA<List<SuggestionModel>>());
      expect(suggestions.length, 2);

      expect(suggestions[0].name, 'Fruits');
      expect(suggestions[1].name, 'Vegetables');
    });
  });

  group('SuggestionModel Tests: ', () {
    late dynamic json;

    setUp(() {
      json = {
        'id': '1',
        'name': 'Apple',
      };
    });

    tearDown(() {});

    test('fromJson should return list of SuggestionModel', () {
      final suggestionModel = SuggestionModel.fromJson(
        json as Map<String, dynamic>,
      );

      expect(suggestionModel.id, '1');
      expect(suggestionModel.name, 'Apple');
    });
  });
}
