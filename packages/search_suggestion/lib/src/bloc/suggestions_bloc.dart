import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/suggestion_model.dart';
import '../data/suggestions_repository.dart';

part 'suggestions_event.dart';
part 'suggestions_state.dart';

class SuggestionsBloc extends Bloc<SuggestionsEvent, SuggestionsState> {
  final SuggestionsRepository suggestionsRepository;

  SuggestionsBloc({required this.suggestionsRepository})
      : super(SuggestionsInitial()) {
    on<FetchSuggestions>(_fetchSuggestions);
  }

  Future<void> _fetchSuggestions(
    FetchSuggestions event,
    Emitter<SuggestionsState> emit,
  ) async {
    emit(SuggestionsLoading());
    try {
      List<SuggestionModel> suggestionsList =
          await suggestionsRepository.loadSuggestions();

      if (suggestionsList.isNotEmpty) {
        List<String> suggestions = suggestionsList.map((e) => e.name).toList();
        emit(SuggestionsLoaded(suggestions));
      } else {
        emit(SuggestionsLoaded([]));
      }
    } catch (_) {
      emit(SuggestionsFailedLoading());
    }
  }
}
