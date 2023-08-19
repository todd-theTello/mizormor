///
class Payment {
  ///
  const Payment({required this.tripId, required this.amount, required this.mobileMoneyNumber, required this.busStop});
  final String tripId;
  final String busStop;
  final double amount;
  final String mobileMoneyNumber;

  ///
  Map<String, dynamic> toJson() => {
        'trip_id': tripId,
        'amount': amount,
        'phone_number': mobileMoneyNumber,
        'bus_stop': busStop,
      };
}
