part of 'suggestions_bloc.dart';

abstract class SuggestionsEvent extends Equatable {
  const SuggestionsEvent();

  @override
  List<Object> get props => [];
}

class FetchSuggestions extends SuggestionsEvent {}
