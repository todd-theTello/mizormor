part of 'states_notifiers.dart';

///
abstract class TripStates extends Equatable {}

///
class TripInitial extends TripStates {
  @override
  List<Object?> get props => [];
}

///
class TripLoading extends TripStates {
  @override
  List<Object?> get props => [];
}

///
class TripSuccess extends TripStates {
  ///
  TripSuccess({required this.trips});

  ///
  final List<Trips> trips;
  @override
  List<Object?> get props => [trips];
}

///
class UserTripSuccess extends TripStates {
  ///
  UserTripSuccess({required this.trips});

  ///
  final List<UserTrips> trips;
  @override
  List<Object?> get props => [trips];
}

///
class TripPaymentSuccess extends TripStates {
  @override
  List<Object?> get props => [];
}

///
class TripFailure extends TripStates {
  TripFailure({required this.error});
  final String error;
  @override
  List<Object?> get props => [error];
}
