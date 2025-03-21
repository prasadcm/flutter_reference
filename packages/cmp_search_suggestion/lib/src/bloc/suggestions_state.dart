part of 'suggestions_bloc.dart';

class SuggestionsState extends Equatable {
  const SuggestionsState();

  @override
  List<Object> get props => [];
}

class SuggestionsInitial extends SuggestionsState {}

class SuggestionsLoading extends SuggestionsState {}

class SuggestionsLoaded extends SuggestionsState {
  final dynamic _suggestions;

  const SuggestionsLoaded(this._suggestions);

  List<String> get getSuggestions => _suggestions;

  @override
  List<Object> get props => [_suggestions];
}

class SuggestionsFailedLoading extends SuggestionsState {}
