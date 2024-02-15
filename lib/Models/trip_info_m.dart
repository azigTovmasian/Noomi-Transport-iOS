class TripInfoM {
  final int tripId;
  final String driverPhoneNumber;
  final String clientName;
  final String tripDescription;
  final DateTime pickupTime;
  final DateTime dropoffTime;
  final String pickupLocation;
  final String dropoffLocation;
  final String comment1;
  final String comment2;
  final String note;
  final int numberOfPassengers;
  final String driverFullName;

  TripInfoM({
    required this.tripId,
    required this.driverPhoneNumber,
    required this.clientName,
    required this.tripDescription,
    required this.pickupTime,
    required this.dropoffTime,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.comment1,
    required this.comment2,
    required this.note,
    required this.numberOfPassengers,
    required this.driverFullName,
  });

  factory TripInfoM.fromJson(Map<String, dynamic> json) {
    return TripInfoM(
      tripId: json['trip_id'],
      driverPhoneNumber: json['driver_phone_number'],
      clientName: json['client_name'],
      tripDescription: json['trip_description'],
      pickupTime: DateTime.parse(json['pickup_time']),
      dropoffTime: DateTime.parse(json['dropoff_time']),
      pickupLocation: json['pickup_location'],
      dropoffLocation: json['dropoff_location'],
      comment1: json['comment_1'],
      comment2: json['comment_2'],
      note: json['note'],
      numberOfPassengers: json['number_of_passengers'],
      driverFullName: json['driver_full_name'],
    );
  }
}
