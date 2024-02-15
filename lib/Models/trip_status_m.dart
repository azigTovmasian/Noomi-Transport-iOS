class TripStatusM {
  final String tripId;
  final String driverPhoneNumber;
  final bool isTripStarted;
  final DateTime tripDateTime;
  final bool isPickedUp;
  final DateTime pickUpDateTime;
  final bool isCompleted;
  final DateTime completeDateTime;

  TripStatusM({
    required this.tripId,
    required this.driverPhoneNumber,
    required this.isTripStarted,
    required this.tripDateTime,
    required this.isPickedUp,
    required this.pickUpDateTime,
    required this.isCompleted,
    required this.completeDateTime,
  });

  factory TripStatusM.fromJson(Map<String, dynamic> json) {
    return TripStatusM(
      tripId: json['tripId'],
      driverPhoneNumber: json['driverPhoneNumber'],
      isTripStarted: json['isTripStarted'],
      tripDateTime: DateTime.parse(json['tripDateTime']),
      isPickedUp: json['isPickedUp'],
      pickUpDateTime: DateTime.parse(json['pickUpDateTime']),
      isCompleted: json['isCompleted'],
      completeDateTime: DateTime.parse(json['completeDateTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tripId': tripId,
      'driverPhoneNumber': driverPhoneNumber,
      'isTripStarted': isTripStarted,
      'tripDateTime': tripDateTime.toIso8601String(),
      'isPickedUp': isPickedUp,
      'pickUpDateTime': pickUpDateTime.toIso8601String(),
      'isCompleted': isCompleted,
      'completeDateTime': completeDateTime.toIso8601String(),
    };
  }
}
