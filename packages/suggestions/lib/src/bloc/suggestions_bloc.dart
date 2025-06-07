import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:suggestions/src/data/suggestion_view_model.dart';
import 'package:suggestions/suggestions.dart';

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
    if (cache != null && cache.isExpired == false) {
      emit(
        SuggestionsLoaded(
          suggestions: _transform(cache.value),
        ),
      );
      return;
    }
    emit(SuggestionsLoading());
    try {
      final suggestionsList = await suggestionsRepository.loadSuggestions();
      emit(
        SuggestionsLoaded(
          suggestions: _transform(suggestionsList),
        ),
      );
    } on SocketException {
      if (cache != null) {
        emit(
          SuggestionsOffline(
            cachedSuggestions: _transform(cache.value),
          ),
        );
      } else {
        emit(const SuggestionsOffline());
      }
    } on Exception {
      emit(
        SuggestionsFailedLoading(
          cachedSuggestions: _transform(cache?.value ?? []),
        ),
      );
    }
  }

  List<SuggestionViewModel> _transform(
    List<SuggestionModel> suggestionList,
  ) {
    return suggestionList
        .map(
          (item) => SuggestionViewModel(
            name: item.name,
          ),
        )
        .toList();
  }
}
