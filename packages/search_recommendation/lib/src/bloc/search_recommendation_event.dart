part of 'search_recommendation_bloc.dart';

abstract class SearchRecommendationEvent extends Equatable {
  const SearchRecommendationEvent();

  @override
  List<Object> get props => [];
}

class FetchSearchRecommendation extends SearchRecommendationEvent {}
