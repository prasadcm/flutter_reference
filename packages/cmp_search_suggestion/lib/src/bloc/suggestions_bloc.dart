import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/suggestion_model.dart';
import '../data/suggestions_repository.dart';

part 'suggestions_event.dart';
part 'suggestions_state.dart';

class SuggestionsBloc extends Bloc<SuggestionsEvent, SuggestionsState> {
  final SuggestionsRepository suggestionsRepository;
  List<String> _categories = [];

  SuggestionsBloc({required this.suggestionsRepository})
      : super(SuggestionsState([])) {
    on<EmitSuggestions>(_emitCategories);
    _fetchCategories();
  }

  void _emitCategories(
    EmitSuggestions event,
    Emitter<SuggestionsState> emit,
  ) {
    emit(SuggestionsState(_categories));
  }

  Future<void> _fetchCategories() async {
    try {
      List<SuggestionModel> categoriesList =
          await suggestionsRepository.loadSuggestions();
      if (categoriesList.isNotEmpty) {
        _categories = categoriesList.map((e) => e.name).toList();
      }
      add(EmitSuggestions());
    } catch (_) {}
  }
}
