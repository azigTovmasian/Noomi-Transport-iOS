class TripM {
  final int id;
  final int tripNumber;
  final Client clients;
  final DateTime date;
  final DateTime pickupTime;
  final DateTime dropoffTime;
  final String pickupLocation;
  final String dropoffLocation;
  final String comment1;
  final String comment2;
  final String note;
  final int numOfPassengers;
  int? status;

  TripM({
    required this.id,
    required this.tripNumber,
    required this.clients,
    required this.date,
    required this.pickupTime,
    required this.dropoffTime,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.comment1,
    required this.comment2,
    required this.note,
    required this.numOfPassengers,
    this.status,
  }) {
    this.status ??= 0;
  }

  factory TripM.fromJson(Map<String, dynamic> json) {
    return TripM(
      id: json['ID'],
      tripNumber: json["TripNumber"],
      clients: Client.fromJson(json['clients']),
      date: DateTime.parse(json['TripDate'] ?? ''),
      pickupTime: DateTime.parse(json['PickupDateTime'] ?? ''),
      dropoffTime: DateTime.parse(json['DropofDateTime'] ?? ''),
      pickupLocation: json['PickupLocation'] ?? ' ',
      dropoffLocation: json['DropofLocation'] ?? ' ',
      comment1: json['Comment1'] ?? ' ',
      comment2: json['Comment2'] ?? ' ',
      note: json['Note'] ?? ' ',
      numOfPassengers: json['NumberofPassengers'] ?? 0,
      status: json['Stauts'] ?? 0,
    );
  }
}

class Client {
  final int? Id;
  final String FirstName;
  final String LastName;
  final String PhoneNumber;
  final String Trips;

  Client({
    this.Id,
    required this.FirstName,
    required this.LastName,
    required this.PhoneNumber,
    required this.Trips,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      Id: json['ID'],
      FirstName: json['FirstName'] ?? '',
      LastName: json['LastName'] ?? '',
      PhoneNumber: json['PhoneNumber'] ?? '',
      Trips: json['Trips'] ?? '',
    );
  }
}
