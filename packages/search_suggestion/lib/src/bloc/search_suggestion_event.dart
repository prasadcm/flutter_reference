part of 'search_suggestion_bloc.dart';

abstract class SearchSuggestionEvent extends Equatable {
  const SearchSuggestionEvent();

  @override
  List<Object> get props => [];
}

class SearchQueryChanged extends SearchSuggestionEvent {
  const SearchQueryChanged(this.query);
  final String query;

  @override
  List<Object> get props => [query];
}
