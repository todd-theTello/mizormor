part of 'states_notifiers.dart';

///
final tripStateProvider = StateNotifierProvider<TripsStateNotifier, TripStates>(
  (ref) => TripsStateNotifier(),
);

///
final userTripStateProvider = StateNotifierProvider<UserTripsStateNotifier, TripStates>(
  (ref) => UserTripsStateNotifier(),
);
final tripPaymentStateProvider = StateNotifierProvider<TripsPaymentStateNotifier, TripStates>(
  (ref) => TripsPaymentStateNotifier(ref: ref),
);
