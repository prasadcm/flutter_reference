import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:suggestions/src/data/suggestions_repository.dart';

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
    final cache = suggestionsRepository.cachedSuggestions;
    final isCacheValid = suggestionsRepository.isCacheValid;
    if (cache != null && isCacheValid) {
      emit(SuggestionsLoaded(suggestions: cache));
      return;
    }
    emit(SuggestionsLoading());
    try {
      final suggestionsList = await suggestionsRepository.loadSuggestions();
      emit(SuggestionsLoaded(suggestions: suggestionsList));
    } on SocketException {
      if (cache != null) {
        emit(SuggestionsOffline(cachedSuggestions: cache));
      } else {
        emit(const SuggestionsOffline());
      }
    } on Exception {
      emit(SuggestionsFailedLoading(cachedSuggestions: cache));
    }
  }
}
