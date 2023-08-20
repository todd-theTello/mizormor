import 'package:cloud_firestore/cloud_firestore.dart';

class UserTrips {
  const UserTrips({
    required this.bus,
    required this.date,
    required this.departureTime,
    required this.destination,
    required this.pickupPoint,
    required this.seatNo,
    required this.ticketId,
    required this.ticketPrice,
    required this.tripId,
    required this.tripStatus,
    required this.userId,
  });

  /// converts authentication response form json to an authentication response instance
  factory UserTrips.fromJson(Map<String, dynamic> json) => UserTrips(
        bus: json['bus'] as String,
        date: int.parse(json['date'].toString()),
        departureTime: (json['departure_time'] as Timestamp).toDate(),
        destination: json['destination'] as String,
        pickupPoint: json['pickup_point'] as String,
        seatNo: int.parse(json['seat_no'].toString()),
        ticketId: json['ticket_id'] as String,
        ticketPrice: double.parse(json['ticket_price'].toString()),
        tripId: json['trip_id'] as String,
        tripStatus: json['trip_status'] as String,
        userId: json['user_id'] as String,
      );

  final String bus;
  final int date;
  final DateTime departureTime;
  final String destination;
  final String pickupPoint;
  final int seatNo;
  final String ticketId;
  final double ticketPrice;
  final String tripId;
  final String tripStatus;
  final String userId;

  Map<String, dynamic> toJson() => {
        'bus': bus,
        'date': date,
        'departure_time': departureTime,
        'destination': destination,
        'pickup_point': pickupPoint,
        'seat_no': seatNo,
        'ticket_id': ticketId,
        'ticket_price': ticketPrice,
        'trip_id': tripId,
        'trip_status': tripStatus,
        'user_id': userId,
      };
}
