import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network/network.dart';
import 'package:suggestions/suggestions.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SuggestionsRepository Tests with data: ', () {
    late SuggestionsRepository repository;
    late MockApiClient mockApi;
    late String mockApiData;

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
      repository = SuggestionsRepository(mockApi);
    });

    tearDown(() {
      repository.clearCache();
    });

    test('loadSuggestions should return list of Suggestions', () async {
      when(() => mockApi.get('suggestions')).thenAnswer((_) async {
        return jsonDecode(mockApiData) as Map<String, dynamic>;
      });

      final suggestions = await repository.loadSuggestions();

      expect(suggestions, isA<List<String>>());
      expect(suggestions.length, 2);

      expect(suggestions[0], 'Fruits');
      expect(suggestions[1], 'Vegetables');
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
