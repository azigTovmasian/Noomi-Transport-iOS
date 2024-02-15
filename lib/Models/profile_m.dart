class ProfileM {
  final String id;
  final String firstName;
  final String lastName;
  final int driverNumber;
  final String profileImage;
  final int availabilityDay;
  final String streetAddressLine1;
  final String city;
  final String zipCode;
  final int state;
  final String emergencyContactName;
  final String emergencyContactPhone;
  final String email;
  final String phoneNumber;

  ProfileM({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.driverNumber,
    required this.profileImage,
    required this.availabilityDay,
    required this.streetAddressLine1,
    required this.city,
    required this.zipCode,
    required this.state,
    required this.emergencyContactName,
    required this.emergencyContactPhone,
    required this.email,
    required this.phoneNumber,
  });

  factory ProfileM.fromJson(Map<String, dynamic> json) {
    return ProfileM(
      id: json['Id'] ?? '',
      firstName: json['FirstName'] ?? '',
      lastName: json['LastName'] ?? '',
      driverNumber: json['DriverNumber'] ?? '',
      profileImage: json['ProfileImage'] ?? '',
      availabilityDay: json['AvailabilityDay'] ?? 3,
      streetAddressLine1: json['StreetAddressLine1'] ?? '',
      city: json['City'] ?? '',
      zipCode: json['ZipCode'] ?? '',
      state: json['State'] ?? 0,
      emergencyContactName: json['EmergencyContactName'] ?? '',
      emergencyContactPhone: json['EmergencyContactPhone'] ?? '',
      email: json['Email'] ?? '',
      phoneNumber: json['PhoneNumber'] ?? '',
    );
  }
}
