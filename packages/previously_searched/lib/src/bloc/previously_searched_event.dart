part of 'previously_searched_bloc.dart';

abstract class PreviouslySearchedEvent extends Equatable {
  const PreviouslySearchedEvent();

  @override
  List<Object> get props => [];
}

class FetchPreviouslySearched extends PreviouslySearchedEvent {}
