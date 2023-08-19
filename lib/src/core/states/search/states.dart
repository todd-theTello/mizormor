part of 'state_notifiers.dart';

///
abstract class SearchStates extends Equatable {}

///
class SearchInitial extends SearchStates {
  @override
  List<Object?> get props => [];
}

///
class SearchLoading extends SearchStates {
  @override
  List<Object?> get props => [];
}

///
class SearchSuccess extends SearchStates {
  ///
  SearchSuccess({required this.trip});

  ///
  final Trips? trip;
  @override
  List<Object?> get props => [trip];
}

///
class SearchFailure extends SearchStates {
  @override
  List<Object?> get props => [];
}
