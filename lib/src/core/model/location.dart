///
class Location {
  const Location({required this.locationId, required this.locationName});

  ///
  final String locationId;

  ///
  final String locationName;

  ///
  factory Location.fromJson(Map<String, dynamic> json) => Location(
        locationId: json['location_id'],
        locationName: json['location_name'],
      );
}
