part of 'states_notifiers.dart';

///
final tripStateProvider = StateNotifierProvider<TripsStateNotifier, TripStates>(
  (ref) => TripsStateNotifier(),
);
final tripPaymentStateProvider = StateNotifierProvider<TripsPaymentStateNotifier, TripStates>(
  (ref) => TripsPaymentStateNotifier(),
);
