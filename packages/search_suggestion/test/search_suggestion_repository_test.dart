import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network/network.dart';
import 'package:search_suggestion/src/data/search_suggestion.dart';
import 'package:search_suggestion/src/data/search_suggestion_repository.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SearchSuggestionRepository Tests with data: ', () {
    late SearchSuggestionRepository repository;
    late MockApiClient mockApi;
    late String mockApiData;

    setUp(() {
      mockApi = MockApiClient();
      mockApiData = '''
        {
        "data": {
          "total": 12,
          "results": [
            {
                "iconUrl": "assets/icons/products/atta.jpg",
                "name": "suji rava",
                "type": "category",
                "slug": "",
                "productId": "",
                "categoryId": "suji-1"
            },
            {
                "iconUrl": "assets/icons/products/atta.jpg",
                "name": "sugar",
                "type": "category",
                "slug": "",
                "productId": "",
                "categoryId": "sugar-1"
            }
          ]
        }
      }
      ''';
      repository = SearchSuggestionRepository(apiClient: mockApi);
    });

    tearDown(() {});

    test(
      'loadSearchSuggestion should return list of SearchSuggestion',
      () async {
        when(() => mockApi.get('search_suggestion?query=sug')).thenAnswer((
          _,
        ) async {
          return jsonDecode(mockApiData) as Map<String, dynamic>;
        });
        final suggestion = await repository.loadSearchSuggestion(query: 'sug');

        expect(suggestion, isA<SearchSuggestion>());
        expect(suggestion.items.length, 2);

        expect(suggestion.items[0].name, 'suji rava');
        expect(suggestion.items[1].name, 'sugar');
        expect(suggestion.items[0].iconUrl, 'assets/icons/products/atta.jpg');
        expect(suggestion.items[1].iconUrl, 'assets/icons/products/atta.jpg');
        expect(suggestion.items[0].type, 'category');
        expect(suggestion.items[1].type, 'category');
        expect(suggestion.items[0].slug, '');
        expect(suggestion.items[1].slug, '');
        expect(suggestion.items[0].productId, '');
        expect(suggestion.items[1].productId, '');
        expect(suggestion.items[0].categoryId, 'suji-1');
        expect(suggestion.items[1].categoryId, 'sugar-1');
      },
    );
  });
}
