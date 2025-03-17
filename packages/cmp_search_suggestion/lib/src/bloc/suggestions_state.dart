part of 'suggestions_bloc.dart';

class SuggestionsState extends Equatable {
  final List<String> suggestions;

  const SuggestionsState(this.suggestions);

  @override
  List<Object> get props => [suggestions];
}
