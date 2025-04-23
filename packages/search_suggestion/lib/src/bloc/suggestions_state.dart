part of 'suggestions_bloc.dart';

class SuggestionsState extends Equatable {
  const SuggestionsState();

  @override
  List<Object> get props => [];
}

class SuggestionsInitial extends SuggestionsState {}

class SuggestionsLoading extends SuggestionsState {}

class SuggestionsLoaded extends SuggestionsState {
  const SuggestionsLoaded(this._suggestions);
  final List<String> _suggestions;

  List<String> get getSuggestions => _suggestions;

  @override
  List<Object> get props => [_suggestions];
}

class SuggestionsFailedLoading extends SuggestionsState {}
