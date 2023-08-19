/// Trips entity
class Bus {
  ///
  const Bus({
    required this.busId,
    required this.registrationNumber,
    required this.seatCapacity,
  });

  ///
  factory Bus.fromJson(Map<String, dynamic> json) => Bus(
        busId: json['bus_id'] as String,
        registrationNumber: json['registration_number'] as String,
        seatCapacity: json['seat_capacity'] as int,
      );

  ///
  final String busId;

  ///
  final String registrationNumber;

  ///
  final int seatCapacity;
}
