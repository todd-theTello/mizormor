part of 'repositories.dart';

///
class TripsRepository {
  /// get all trips
  Future<BaseResponse<List<Trips>>> getTrips() async {
    try {
      final firebaseTrips = await FirebaseFirestore.instance.collection('trips').get();
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

  Future<BaseResponse<List<UserTrips>>> getUserTrips() async {
    try {
      final firebaseTrips = await FirebaseFirestore.instance.collection('user_trips').get();
      final userTrips = List<UserTrips>.from(
        (firebaseTrips.docs).map(
          (e) => UserTrips.fromJson(e.data()),
        ),
      );
      return BaseResponse.success(userTrips);
    } on FirebaseException catch (err) {
      return BaseResponse.error(message: err.message);
    } catch (err) {
      return BaseResponse.error(message: err.toString());
    }
  }
}
