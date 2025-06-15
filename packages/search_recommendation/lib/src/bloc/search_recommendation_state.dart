part of 'search_recommendation_bloc.dart';

class SearchRecommendationState extends Equatable {
  const SearchRecommendationState();

  @override
  List<Object> get props => [];
}

class SearchRecommendationInitial extends SearchRecommendationState {}

class SearchRecommendationLoading extends SearchRecommendationState {}

class SearchRecommendationLoaded extends SearchRecommendationState {
  const SearchRecommendationLoaded({required this.recommendations});
  final List<SearchRecommendationViewModel> recommendations;

  @override
  List<Object> get props => [recommendations];
}

class EmptySearchRecommendation extends SearchRecommendationState {}

class SearchRecommendationFailedLoading extends SearchRecommendationState {
  const SearchRecommendationFailedLoading({this.cachedSearchRecommendation});
  final List<SearchRecommendationViewModel>? cachedSearchRecommendation;

  List<SearchRecommendationViewModel> get cachedRecommendation =>
      cachedSearchRecommendation ?? [];

  @override
  List<Object> get props => [cachedSearchRecommendation ?? []];
}

class SearchRecommendationOffline extends SearchRecommendationState {
  const SearchRecommendationOffline({this.cachedSearchRecommendation});
  final List<SearchRecommendationViewModel>? cachedSearchRecommendation;

  List<SearchRecommendationViewModel> get cachedRecommendation =>
      cachedSearchRecommendation ?? [];

  @override
  List<Object> get props => [cachedSearchRecommendation ?? []];
}
