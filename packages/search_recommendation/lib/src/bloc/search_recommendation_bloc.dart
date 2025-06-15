import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:search_recommendation/search_recommendation.dart';
import 'package:search_recommendation/src/data/search_recommendation_view_model.dart';

part 'search_recommendation_event.dart';
part 'search_recommendation_state.dart';

class SearchRecommendationBloc
    extends Bloc<SearchRecommendationEvent, SearchRecommendationState> {
  SearchRecommendationBloc({required this.recommendationRepository})
      : super(SearchRecommendationInitial()) {
    on<FetchSearchRecommendation>(_fetchSearchRecommendation);
  }
  final SearchRecommendationRepository recommendationRepository;

  Future<void> _fetchSearchRecommendation(
    FetchSearchRecommendation event,
    Emitter<SearchRecommendationState> emit,
  ) async {
    final cache = recommendationRepository.cachedSearchRecommendation;
    if (cache != null && cache.isExpired == false) {
      emit(
        SearchRecommendationLoaded(
          recommendations: _transform(cache.value),
        ),
      );
      return;
    }
    emit(SearchRecommendationLoading());
    try {
      final recommendationsList =
          await recommendationRepository.loadSearchRecommendation();
      emit(
        SearchRecommendationLoaded(
          recommendations: _transform(recommendationsList),
        ),
      );
    } on SocketException {
      if (cache != null) {
        emit(
          SearchRecommendationOffline(
            cachedSearchRecommendation: _transform(cache.value),
          ),
        );
      } else {
        emit(const SearchRecommendationOffline());
      }
    } on Exception {
      emit(
        SearchRecommendationFailedLoading(
          cachedSearchRecommendation: _transform(cache?.value ?? []),
        ),
      );
    }
  }

  List<SearchRecommendationViewModel> _transform(
    List<SearchRecommendationModel> suggestionList,
  ) {
    return suggestionList
        .map(
          (item) => SearchRecommendationViewModel(
            name: item.name,
          ),
        )
        .toList();
  }
}
