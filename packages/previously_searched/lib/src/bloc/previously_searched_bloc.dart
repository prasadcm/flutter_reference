import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:previously_searched/previously_searched.dart';
import 'package:previously_searched/src/data/previously_searched_item.dart';
import 'package:previously_searched/src/data/previously_searched_repository.dart';

part 'previously_searched_event.dart';
part 'previously_searched_state.dart';

class PreviouslySearchedBloc
    extends Bloc<PreviouslySearchedEvent, PreviouslySearchedState> {
  PreviouslySearchedBloc({required this.searchRepository})
    : super(PreviouslySearchedInitial()) {
    on<FetchPreviouslySearched>(_fetchPreviouslySearched);
  }
  final PreviouslySearchedRepository searchRepository;

  Future<void> _fetchPreviouslySearched(
    FetchPreviouslySearched event,
    Emitter<PreviouslySearchedState> emit,
  ) async {
    final cache = searchRepository.cachedPreviouslySearched;
    if (cache != null && cache.isExpired == false) {
      emit(
        PreviouslySearchedLoaded(
          previouslySearchedItems: _transform(cache.value),
        ),
      );
      return;
    }
    emit(PreviouslySearchedLoading());
    try {
      final searchList = await searchRepository.loadPreviouslySearched();
      emit(
        PreviouslySearchedLoaded(
          previouslySearchedItems: _transform(searchList),
        ),
      );
    } on SocketException {
      if (cache != null) {
        emit(
          PreviouslySearchedOffline(
            cachedPreviouslySearched: _transform(cache.value),
          ),
        );
      } else {
        emit(const PreviouslySearchedOffline());
      }
    } on Exception {
      emit(
        PreviouslySearchedFailedLoading(
          cachedPreviouslySearched: _transform(cache?.value ?? []),
        ),
      );
    }
  }

  List<PreviouslySearchedItemViewModel> _transform(
    List<PreviouslySearchedItem> searchList,
  ) {
    return searchList
        .map(
          (item) => PreviouslySearchedItemViewModel(
            name: item.searchText,
            iconUrl: item.iconUrl ?? '',
          ),
        )
        .toList();
  }
}
