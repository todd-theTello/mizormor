///
class TripRequestData {
  /// Login request data constructor
  const TripRequestData({
    required this.destination,
    required this.departureDate,
  });

  ///
  final String destination;

  ///
  final DateTime departureDate;

  ///
  Map<String, dynamic> toJson() => {
        'destination': destination,
        'departure_time': departureDate,
      };
}
