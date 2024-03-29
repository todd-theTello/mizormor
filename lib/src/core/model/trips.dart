import 'package:cloud_firestore/cloud_firestore.dart';

/// Trips entity
class Trips {
  ///
  const Trips({
    required this.tripId,
    required this.bus,
    required this.pickupPoint,
    required this.destination,
    required this.ticketPrice,
    required this.departureTime,
    required this.tripStatus,
    required this.passengers,
    required this.passengerIds,
    required this.date,
    required this.seatCapacity,
  });

  ///
  factory Trips.fromJson(Map<String, dynamic> json) => Trips(
        tripId: json['trip_id'] as String,
        bus: json['bus'],
        destination: json['destination'],
        pickupPoint: List<String>.from(
          (json['pick_up_points'] as List<dynamic>).map((e) => e),
        ),
        passengerIds: List<String>.from(
          (json['passenger_ids'] as List<dynamic>).map((e) => e),
        ),
        ticketPrice: double.parse(json['ticket_price'].toString()),
        departureTime: (json['departure_time'] as Timestamp).toDate(),
        tripStatus: json['status'] as String,
        seatCapacity: int.parse(json['seat_capacity'].toString()),
        date: int.parse(json['date'].toString()),
        passengers: json['passengers'] == null
            ? []
            : List<TripPassengers>.from(
                (json['passengers'] as List<dynamic>).map(
                  (e) => TripPassengers.fromJson(e),
                ),
              ),
      );

  ///
  final String tripId;

  ///
  final String bus;

  ///
  final int date;

  ///
  final String destination;

  ///
  final DateTime departureTime;

  ///
  final String tripStatus;

  ///
  final List<String> pickupPoint;

  ///
  final List<String> passengerIds;

  ///
  final double ticketPrice;

  ///
  final List<TripPassengers> passengers;
  final int seatCapacity;

  ///
  Map<String, dynamic> toJson() => {
        'trip_id': tripId,
      };
}

class TripPassengers {
  const TripPassengers({required this.pickupPoint, required this.userId});

  ///
  factory TripPassengers.fromJson(Map<String, dynamic> json) => TripPassengers(
        pickupPoint: json['pickup_point'] as String,
        userId: json['user_id'],
      );
  final String pickupPoint;
  final String userId;
}
