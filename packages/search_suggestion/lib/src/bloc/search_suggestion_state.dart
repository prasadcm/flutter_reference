part of 'search_suggestion_bloc.dart';

class SearchSuggestionState extends Equatable {
  const SearchSuggestionState();

  @override
  List<Object> get props => [];
}

class SearchSuggestionInitial extends SearchSuggestionState {}

class SearchSuggestionLoading extends SearchSuggestionState {}

class SearchSuggestionLoaded extends SearchSuggestionState {
  const SearchSuggestionLoaded({
    required this.searchSuggestion,
    required this.query,
  });
  final String query;
  final SearchSuggestionViewModel searchSuggestion;

  @override
  List<Object> get props => [query, searchSuggestion];
}

class EmptySearchSuggestion extends SearchSuggestionState {}

class SearchSuggestionFailedLoading extends SearchSuggestionState {}

class SearchSuggestionOffline extends SearchSuggestionState {}
