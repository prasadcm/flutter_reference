part of 'suggestions_bloc.dart';

class SuggestionsState extends Equatable {
  const SuggestionsState();

  @override
  List<Object> get props => [];
}

class SuggestionsInitial extends SuggestionsState {}

class SuggestionsLoading extends SuggestionsState {}

class SuggestionsLoaded extends SuggestionsState {
  const SuggestionsLoaded({required this.suggestions});
  final List<String> suggestions;

  List<String> get getSuggestions => suggestions;

  @override
  List<Object> get props => [suggestions];
}

class EmptySuggestions extends SuggestionsState {}

class SuggestionsFailedLoading extends SuggestionsState {
  const SuggestionsFailedLoading({this.cachedSuggestions});
  final List<String>? cachedSuggestions;

  List<String> get getCachedCategories => cachedSuggestions ?? [];

  @override
  List<Object> get props => [cachedSuggestions ?? []];
}

class SuggestionsOffline extends SuggestionsState {
  const SuggestionsOffline({this.cachedSuggestions});
  final List<String>? cachedSuggestions;

  List<String> get getCachedSuggestions => cachedSuggestions ?? [];

  @override
  List<Object> get props => [cachedSuggestions ?? []];
}
