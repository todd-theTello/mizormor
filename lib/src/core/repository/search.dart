part of 'repositories.dart';

class SearchRepository {
  Future<BaseResponse<List<Trips>>> getTrips({required TripRequestData data}) async {
    try {
      final int date = int.parse(
        '${data.departureDate.day.toString().padLeft(2, '0')}${data.departureDate.month.toString().padLeft(2, '0')}${data.departureDate.year}',
      );

      date.log();
      data.destination.capitalize.log();
      final firebaseTrips = await FirebaseFirestore.instance
          .collection('trips')
          .where('date', isEqualTo: date)
          .where('status', isEqualTo: 'NOT STARTED')
          .where('passenger_ids', arrayContains: LocalPreference.userID)
          .where('destination', isEqualTo: data.destination.capitalize)
          .get();
      final trips = List<Trips>.from((firebaseTrips.docs).map(
        (e) => Trips.fromJson(e.data()),
      ));

      return BaseResponse.success(trips);
    } on FirebaseException catch (err) {
      return BaseResponse.error(message: err.message);
    } catch (err) {
      return BaseResponse.error(message: err.toString());
    }
  }

  Future<BaseResponse<List<Trips>>> getAllTrips() async {
    try {
      final firebaseTrips = await FirebaseFirestore.instance
          .collection('trips')
          .where('status', isEqualTo: 'NOT STARTED')
          .where('passenger_ids', arrayContains: LocalPreference.userID)
          .get();
      final trips = List<Trips>.from((firebaseTrips.docs).map(
        (e) => Trips.fromJson(e.data()),
      ));

      return BaseResponse.success(trips);
    } on FirebaseException catch (err) {
      return BaseResponse.error(message: err.message);
    } catch (err) {
      return BaseResponse.error(message: err.toString());
    }
  }
}
