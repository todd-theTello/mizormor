part of 'repositories.dart';

class PaymentsRepository {
  Future<BaseResponse<String>> makePayment({
    required String tripId,
    required String pickupPoint,
    required MizormorUserInfo user,
  }) async {
    try {
      final firebaseTrips =
          await FirebaseFirestore.instance.collection('trips').where('trip_id', isEqualTo: tripId).get();
      final tripPassengers = await firebaseTrips.docChanges.last.doc.reference.collection('passengers').get();
      if (tripPassengers.docs.length < firebaseTrips.docs.first.data()['seat_capacity']) {
        firebaseTrips.docChanges.first.doc.reference.collection('passengers').doc(user.userId).set(
              user.toJson()
                ..addAll({
                  'pickup_point': pickupPoint,
                  'user_id': user.userId,
                }),
            );
        final passengersId = (firebaseTrips.docs.first.data()['passenger_ids'] as List<String>?) ?? [];
        passengersId.add(user.userId!);
        firebaseTrips.docs.first.reference.update({'passenger_ids': passengersId});
      } else {
        return BaseResponse.error(message: 'Trip fully booked');
      }
      return BaseResponse.success('You have successfully booked a trip');
    } on FirebaseException catch (err) {
      return BaseResponse.error(message: err.message);
    } catch (err) {
      return BaseResponse.error(message: err.toString());
    }
  }
}
