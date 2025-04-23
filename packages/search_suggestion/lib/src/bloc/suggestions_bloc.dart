import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:search_suggestion/src/data/suggestions_repository.dart';

part 'suggestions_event.dart';
part 'suggestions_state.dart';

class SuggestionsBloc extends Bloc<SuggestionsEvent, SuggestionsState> {
  SuggestionsBloc({required this.suggestionsRepository})
      : super(SuggestionsInitial()) {
    on<FetchSuggestions>(_fetchSuggestions);
  }
  final SuggestionsRepository suggestionsRepository;

  Future<void> _fetchSuggestions(
    FetchSuggestions event,
    Emitter<SuggestionsState> emit,
  ) async {
    emit(SuggestionsLoading());
    try {
      final suggestionsList = await suggestionsRepository.loadSuggestions();

      if (suggestionsList.isNotEmpty) {
        final suggestions = suggestionsList.map((e) => e.name).toList();
        emit(SuggestionsLoaded(suggestions));
      } else {
        emit(const SuggestionsLoaded(<String>[]));
      }
    } on Exception {
      emit(SuggestionsFailedLoading());
    }
  }
}
