import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:search_suggestion/search_suggestion.dart';
import 'package:search_suggestion/src/data/search_suggestion.dart';
import 'package:search_suggestion/src/data/search_suggestion_repository.dart';

class MockSearchSuggestionRepository extends Mock
    implements SearchSuggestionRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SearchSuggestionBloc Tests', () {
    late MockSearchSuggestionRepository mockRepository;
    late SearchSuggestionBloc suggestionBloc;
    late SearchSuggestion mockSearchSuggestion;
    late SearchSuggestionViewModel mockSearchSuggestionViewModel;

    setUp(() {
      mockRepository = MockSearchSuggestionRepository();
      suggestionBloc = SearchSuggestionBloc(searchRepository: mockRepository);
      mockSearchSuggestion = const SearchSuggestion(
        total: 2,
        items: [
          SearchSuggestionItem(
            iconUrl: 'assets/icons/products/apple.jpg',
            name: 'Apple',
            type: 'category',
            slug: '',
            productId: '',
            categoryId: 'apple-1',
          ),
          SearchSuggestionItem(
            name: 'Banana',
            type: 'category',
            slug: '',
            productId: '',
            categoryId: 'banana-1',
          ),
        ],
      );
      mockSearchSuggestionViewModel = const SearchSuggestionViewModel(
        total: 1,
        suggestions: [
          SearchSuggestionItemViewModel(
            iconUrl: 'assets/icons/products/apple.jpg',
            name: 'Apple',
            type: 'category',
            slug: '',
            productId: '',
            categoryId: 'apple-1',
          ),
          SearchSuggestionItemViewModel(
            iconUrl: 'assets/icons/products/banana.jpg',
            name: 'Banana',
            type: 'category',
            slug: '',
            productId: '',
            categoryId: 'banana-1',
          ),
        ],
      );
    });

    tearDown(() {
      suggestionBloc.close();
    });

    blocTest<SearchSuggestionBloc, SearchSuggestionState>(
      'emits [SearchSuggestionLoading,SearchSuggestionLoaded] when FetchSearchSuggestion is triggered',
      build: () {
        when(
          () => mockRepository.loadSearchSuggestion(query: any(named: 'query')),
        ).thenAnswer((_) async => mockSearchSuggestion);
        return suggestionBloc;
      },
      act: (bloc) => bloc.add(const SearchQueryChanged('Banana')),
      expect:
          () => [isA<SearchSuggestionLoading>(), isA<SearchSuggestionLoaded>()],
    );

    blocTest<SearchSuggestionBloc, SearchSuggestionState>(
      'FetchSearchSuggestion transforms suggestion to view models',
      build: () {
        when(
          () => mockRepository.loadSearchSuggestion(query: any(named: 'query')),
        ).thenAnswer((_) async => mockSearchSuggestion);
        return suggestionBloc;
      },
      act: (bloc) => bloc.add(const SearchQueryChanged('Banana')),
      expect:
          () => [isA<SearchSuggestionLoading>(), isA<SearchSuggestionLoaded>()],
      verify: (bloc) {
        final state = bloc.state as SearchSuggestionLoaded;
        expect(
          state.searchSuggestion.suggestions[0].name,
          equals(mockSearchSuggestionViewModel.suggestions[0].name),
        );
        expect(
          state.searchSuggestion.suggestions[1].name,
          equals(mockSearchSuggestionViewModel.suggestions[1].name),
        );
        expect(
          state.searchSuggestion.suggestions.length,
          equals(mockSearchSuggestionViewModel.suggestions.length),
        );
      },
    );

    blocTest<SearchSuggestionBloc, SearchSuggestionState>(
      'emits [SearchSuggestionLoading, SearchSuggestionFailedLoading] when repository fails to load',
      build: () {
        when(
          () => mockRepository.loadSearchSuggestion(query: any(named: 'query')),
        ).thenThrow(Exception('Failed to load suggestions'));
        return suggestionBloc;
      },
      act: (bloc) => bloc.add(const SearchQueryChanged('Banana')),
      expect:
          () => [SearchSuggestionLoading(), SearchSuggestionFailedLoading()],
    );

    blocTest<SearchSuggestionBloc, SearchSuggestionState>(
      'emits [SearchSuggestionLoaded] when search query is empty',
      build: () {
        return suggestionBloc;
      },
      act: (bloc) => bloc.add(const SearchQueryChanged('')),
      expect: () => [isA<SearchSuggestionLoaded>()],

      verify: (bloc) {
        final state = bloc.state as SearchSuggestionLoaded;
        expect(state.searchSuggestion.total, equals(0));
        expect(state.searchSuggestion.suggestions, equals([]));
      },
    );

    blocTest<SearchSuggestionBloc, SearchSuggestionState>(
      'emits [SearchSuggestionLoading, SearchSuggestionOffline] when offline',
      build: () {
        when(
          () => mockRepository.loadSearchSuggestion(query: any(named: 'query')),
        ).thenThrow(const SocketException('No Internet'));
        return suggestionBloc;
      },
      act: (bloc) => bloc.add(const SearchQueryChanged('xxx')),
      expect: () => [SearchSuggestionLoading(), SearchSuggestionOffline()],
    );
  });
}
