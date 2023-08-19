part of 'repositories.dart';

///
class TripsRepository {
  /// get all trips
  Future<BaseResponse<List<Trips>>> getTrips() async {
    try {
      final firebaseTrips = await FirebaseFirestore.instance.collection('trips').get();
      final tripPassengers = await firebaseTrips.docChanges.last.doc.reference.collection('passengers').get();
      final trips = List<Trips>.from((firebaseTrips.docs).map(
        (e) => Trips.fromJson(e.data()),
      ));
      final passengers = List<TripPassengers>.from((tripPassengers.docs).map(
        (e) => TripPassengers.fromJson(e.data()),
      ));

      final finalTrips = trips
          .map(
            (e) => Trips(
              tripId: e.tripId,
              bus: e.bus,
              pickupPoint: e.pickupPoint,
              destination: e.destination,
              ticketPrice: e.ticketPrice,
              departureTime: e.departureTime,
              tripStatus: e.tripStatus,
              passengers: passengers,
            ),
          )
          .toList();
      return BaseResponse.success(finalTrips);
    } on FirebaseException catch (err) {
      return BaseResponse.error(message: err.message);
    } catch (err) {
      return BaseResponse.error(message: err.toString());
    }
  }
}
