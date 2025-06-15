import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:search_suggestion/search_suggestion.dart';
import 'package:search_suggestion/src/data/search_suggestion.dart';
import 'package:search_suggestion/src/data/search_suggestion_repository.dart';

part 'search_suggestion_event.dart';
part 'search_suggestion_state.dart';

class SearchSuggestionBloc
    extends Bloc<SearchSuggestionEvent, SearchSuggestionState> {
  SearchSuggestionBloc({required this.searchRepository})
    : super(SearchSuggestionInitial()) {
    on<SearchQueryChanged>(_fetchSearchSuggestion);
  }
  final SearchSuggestionRepository searchRepository;

  Future<void> _fetchSearchSuggestion(
    SearchQueryChanged event,
    Emitter<SearchSuggestionState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(
        SearchSuggestionLoaded(
          query: event.query,
          searchSuggestion: const SearchSuggestionViewModel(
            suggestions: [],
            total: 0,
          ),
        ),
      );
    } else if (event.query.length < 2) {
      final previouslySearched = _transform(
        searchRepository.previouslySearched,
      );
      emit(
        SearchSuggestionLoaded(
          query: event.query,
          searchSuggestion: previouslySearched,
        ),
      );
    } else {
      emit(SearchSuggestionLoading());
      try {
        final searchList = await searchRepository.loadSearchSuggestion(
          query: event.query,
        );
        emit(
          SearchSuggestionLoaded(
            query: event.query,
            searchSuggestion: _transform(searchList),
          ),
        );
      } on SocketException {
        emit(SearchSuggestionOffline());
      } on Exception {
        emit(SearchSuggestionFailedLoading());
      }
    }
  }

  SearchSuggestionViewModel _transform(SearchSuggestion searchSuggestion) {
    final searchList = searchSuggestion.items;
    if (searchList.isEmpty) {
      return const SearchSuggestionViewModel(suggestions: [], total: 0);
    }
    return SearchSuggestionViewModel(
      suggestions: _transformSearchList(searchList),
      total: searchSuggestion.total,
    );
  }

  List<SearchSuggestionItemViewModel> _transformSearchList(
    List<SearchSuggestionItem> searchList,
  ) {
    return searchList.map((item) {
      return SearchSuggestionItemViewModel(
        iconUrl: item.iconUrl ?? '',
        name: item.name,
        type: item.type,
        slug: item.slug,
        productId: item.productId,
        categoryId: item.categoryId,
      );
    }).toList();
  }
}
