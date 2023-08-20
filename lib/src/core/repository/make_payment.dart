part of 'repositories.dart';

class PaymentsRepository {
  Future<BaseResponse<String>> makePayment({
    required Trips trip,
    required String pickupPoint,
    required MizormorUserInfo user,
  }) async {
    try {
      final trips = await FirebaseFirestore.instance.collection('trips').where('trip_id', isEqualTo: trip.tripId).get();
      final tripPassengers = await trips.docs.first.reference.collection('passengers').get();

      if (tripPassengers.docs.length < trips.docs.first.data()['seat_capacity']) {
        if (tripPassengers.docs.isNotEmpty) {
          await trips.docChanges.first.doc.reference.collection('passengers').doc(user.userId).update(
                user.toJson()
                  ..addAll({
                    'pickup_point': pickupPoint,
                    'user_id': user.userId,
                  }),
              );
        } else {
          await trips.docChanges.first.doc.reference.collection('passengers').doc(user.userId).set(
                user.toJson()
                  ..addAll({
                    'pickup_point': pickupPoint,
                    'user_id': user.userId,
                  }),
              );
        }
        final passengersId = (trips.docs.first.data()['passenger_ids']);
        passengersId.add(user.userId!);
        await FirebaseFirestore.instance.collection('user_trips').doc().set(
          {
            'bus': trip.bus,
            'date': trip.date,
            'departure_time': trip.departureTime,
            'destination': trip.destination,
            'pickup_point': pickupPoint,
            'seat_no': trip.passengers.length + 1,
            'ticket_id':
                'AC${trip.destination.substring(0, 1)}${trip.date}N${(trip.passengers.length + 1).toString().padLeft(3, '0')}',
            'ticket_price': trip.ticketPrice,
            'trip_id': trip.tripId,
            'trip_status': trip.tripStatus,
            'user_id': LocalPreference.userID,
          },
        );
        trips.docs.first.reference.update({'passenger_ids': passengersId});
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
