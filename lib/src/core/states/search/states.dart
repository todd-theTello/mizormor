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
  SearchSuccess({required this.trips});

  ///
  final List<Trips> trips;
  @override
  List<Object?> get props => [trips];
}

///
class SearchFailure extends SearchStates {
  SearchFailure({required this.error});
  final String error;
  @override
  List<Object?> get props => [error];
}
