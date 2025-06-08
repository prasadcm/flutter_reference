part of 'previously_searched_bloc.dart';

class PreviouslySearchedState extends Equatable {
  const PreviouslySearchedState();

  @override
  List<Object> get props => [];
}

class PreviouslySearchedInitial extends PreviouslySearchedState {}

class PreviouslySearchedLoading extends PreviouslySearchedState {}

class PreviouslySearchedLoaded extends PreviouslySearchedState {
  const PreviouslySearchedLoaded({required this.previouslySearchedItems});
  final List<PreviouslySearchedItemViewModel> previouslySearchedItems;

  List<PreviouslySearchedItemViewModel> get previouslySearched =>
      previouslySearchedItems;

  @override
  List<Object> get props => [previouslySearchedItems];
}

class EmptyPreviouslySearched extends PreviouslySearchedState {}

class PreviouslySearchedFailedLoading extends PreviouslySearchedState {
  const PreviouslySearchedFailedLoading({this.cachedPreviouslySearched});
  final List<PreviouslySearchedItemViewModel>? cachedPreviouslySearched;

  List<PreviouslySearchedItemViewModel> get getCachedPreviouslySearched =>
      cachedPreviouslySearched ?? [];

  @override
  List<Object> get props => [cachedPreviouslySearched ?? []];
}

class PreviouslySearchedOffline extends PreviouslySearchedState {
  const PreviouslySearchedOffline({this.cachedPreviouslySearched});
  final List<PreviouslySearchedItemViewModel>? cachedPreviouslySearched;

  List<PreviouslySearchedItemViewModel> get getCachedPreviouslySearched =>
      cachedPreviouslySearched ?? [];

  @override
  List<Object> get props => [cachedPreviouslySearched ?? []];
}
