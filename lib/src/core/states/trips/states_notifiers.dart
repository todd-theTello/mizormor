import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mizormor/src/core/model/user_trip.dart';

import '../../model/trips.dart';
import '../../model/user.dart';
import '../../repository/repositories.dart';

part 'provider.dart';
part 'states.dart';

///
class TripsStateNotifier extends StateNotifier<TripStates> {
  ///
  TripsStateNotifier() : super(TripInitial());
  final TripsRepository _tripsRepository = TripsRepository();

  Future<void> getAllTrips() async {
    try {
      state = TripLoading();
      final response = await _tripsRepository.getTrips();
      if (response.status) {
        state = TripSuccess(trips: response.data!);
      } else {
        state = TripFailure(
          error: response.message ?? "Couldn't fetch all trips",
        );
      }
    } catch (err) {
      state = TripFailure(error: err.toString());
    }
  }
}

class UserTripsStateNotifier extends StateNotifier<TripStates> {
  UserTripsStateNotifier() : super(TripInitial());
  final TripsRepository _tripsRepository = TripsRepository();

  Future<void> getUserTrips() async {
    try {
      state = TripLoading();
      final response = await _tripsRepository.getUserTrips();
      if (response.status) {
        state = UserTripSuccess(trips: response.data!);
      } else {
        state = TripFailure(
          error: response.message ?? "Couldn't fetch all trips",
        );
      }
    } catch (err) {
      state = TripFailure(error: err.toString());
    }
  }
}

class TripsPaymentStateNotifier extends StateNotifier<TripStates> {
  ///
  TripsPaymentStateNotifier() : super(TripInitial());
  final PaymentsRepository _paymentsRepository = PaymentsRepository();

  Future<void> makeTripPayment({
    required Trips trip,
    required String pickupPoint,
    required MizormorUserInfo user,
  }) async {
    try {
      state = TripLoading();
      final response = await _paymentsRepository.makePayment(trip: trip, pickupPoint: pickupPoint, user: user);
      if (response.status) {
        state = TripPaymentSuccess();
      } else {
        state = TripFailure(
          error: response.message ?? "Couldn't fetch all trips",
        );
      }
    } catch (err) {
      state = TripFailure(error: err.toString());
    }
  }
}
