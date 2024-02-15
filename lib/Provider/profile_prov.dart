import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Models/profile_m.dart';
import 'dart:io';

class ProfileProv with ChangeNotifier {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _streetController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _zipController = TextEditingController();
  TextEditingController _contactNameController = TextEditingController();
  TextEditingController _contactPhoneNumberController = TextEditingController();
  ProfileM _profile = ProfileM(
      id: '',
      firstName: '',
      lastName: '',
      driverNumber: 0,
      availabilityDay: 1,
      streetAddressLine1: '',
      city: '',
      zipCode: '',
      state: 1,
      emergencyContactName: '',
      emergencyContactPhone: '',
      email: '',
      profileImage: '',
      phoneNumber: '');
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isSentSuccessfully = false;
  String _dropDownSelectedState = '';
  int _availableDays = 0;
  bool _isImagePicked = false;
  bool _isSaving = false;
  bool get isImagePicked => _isImagePicked;
  int get availableDays => _availableDays;
  TextEditingController get firstNameController => _firstNameController;
  TextEditingController get lastNameController => _lastNameController;
  TextEditingController get emailController => _emailController;
  TextEditingController get phoneNumberController => _phoneNumberController;
  TextEditingController get streetController => _streetController;
  TextEditingController get cityController => _cityController;
  TextEditingController get zipController => _zipController;
  TextEditingController get contactNameController => _contactNameController;
  TextEditingController get contactPhoneNumberController =>
      _contactPhoneNumberController;

  bool get isLoading => _isLoading;
  ProfileM? get profile => _profile;
  String get errorMessage => _errorMessage;
  bool get isSentSuccessfully => _isSentSuccessfully;
  String get dropDownSelectedState => _dropDownSelectedState;
  bool get isSaving => _isSaving;

  void setIsLoding(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setIsSaving(bool value) {
    _isSaving = value;
    notifyListeners();
  }

  void setAvailableDays(int value) {
    _availableDays = value;
    notifyListeners();
  }

  void setAvailableDays2(int value) {
    _availableDays = availableDays;
    notifyListeners();
  }

  void setProfileData() {
    _firstNameController.text = _profile.firstName;
    _lastNameController.text = _profile.lastName;
    _emailController.text = _profile.email;
    _streetController.text = _profile.streetAddressLine1;
    _cityController.text = _profile.city;
    _zipController.text = _profile.zipCode.toString();
    _contactNameController.text = _profile.emergencyContactName;
    _contactPhoneNumberController.text = _profile.emergencyContactPhone;
    _availableDays = _profile.availabilityDay;
    _dropDownSelectedState = getStateName(_profile.state);
    notifyListeners();
  }

  void setIsImagePicked(bool value) {
    _isImagePicked = value;
    notifyListeners();
  }

  void setDropDownSelectedState(String state) {
    _dropDownSelectedState = state;
    notifyListeners();
  }

  Future<void> updateProfile({
    required String driverId,
    required String firstName,
    required String lastName,
    required String city,
    required int state,
    required String emergencyName,
    required String emergencyPhone,
    required String email,
    required String zipCode,
    required String address1,
    File? imageFile,
  }) async {
    String baseUrl = 'https://admin.noomitransport.com/api/AccountService';
    final String url = '$baseUrl/UpdateProfilev1?Id=${driverId}&UserViewModel';

    final Map<String, String> headers = <String, String>{
      'FROM': 'Noomi',
      "DriverID": driverId,
    };

    final Map<String, String> fields = <String, String>{
      'FirstName': firstName,
      'LastName': lastName,
      'AvailabilityDay': _availableDays.toString(),
      'StreetAddressLine1': address1,
      'City': city,
      'ZipCode': zipCode.toString(),
      'State': state.toString(),
      'EmergencyContactName': emergencyName,
      'EmergencyContactPhone': emergencyPhone,
      'Email': email,
    };

    final List<http.MultipartFile> files = <http.MultipartFile>[];
    if (imageFile != null) {
      final String fileName = imageFile.path.split('/').last;
      final http.MultipartFile image =
          await http.MultipartFile.fromPath('ImageFile', imageFile.path);
      files.add(image);
      fields['ImageFile'] = fileName;
    }

    try {
      final http.MultipartRequest request =
          http.MultipartRequest('PUT', Uri.parse(url))
            ..headers.addAll(headers)
            ..fields.addAll(fields)
            ..files.addAll(files);

      final http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        _isSentSuccessfully = true;
      } else {
        final String responseBody = await response.stream.bytesToString();
        final dynamic jsonResponse = jsonDecode(responseBody);
        if (jsonResponse != null &&
            jsonResponse['errorMessage'] != null &&
            jsonResponse['errorMessage']
                .toString()
                .contains("This Email is already in use")) {
          _errorMessage = _errorMessage = "This Email already exists!";
        } else {
          _errorMessage = 'Something went wrong!\nPlease try again later.';
        }
        _isSentSuccessfully = false;
      }
    } catch (error) {
      if (error.toString().contains("This Email is already in use")) {
        _errorMessage = "This Email already exists!";
      } else {
        _errorMessage = error.toString();
      }
      _isSentSuccessfully = false;
      notifyListeners();
    } finally {
      notifyListeners();
    }
  }

  // Future<void> updateProfile({
  //   required String driverId,
  //   required String firstName,
  //   required String lastName,
  //   required String city,
  //   required int state,
  //   required String emergencyName,
  //   required String emergencyPhone,
  //   required String email,
  //   required int zipCode,
  //   required String address1,
  //   File? imageFile,
  // }) async {
  //   String baseUrl = 'https://admin.noomitransport.com/api/AccountService';
  //   final String url = '$baseUrl/UpdateProfilev1?Id=${driverId}&UserViewModel';

  //   final Map<String, String> headers = <String, String>{
  //     'FROM': 'Noomi',
  //     "DriverID": driverId,
  //   };

  //   final Map<String, String> fields = <String, String>{
  //     'FirstName': firstName,
  //     'LastName': lastName,
  //     'AvailabilityDay': _availableDays.toString(),
  //     'StreetAddressLine1': address1,
  //     'City': city,
  //     'ZipCode': zipCode.toString(),
  //     'State': state.toString(),
  //     'EmergencyContactName': emergencyName,
  //     'EmergencyContactPhone': emergencyPhone,
  //     'Email': email,
  //   };

  //   final List<http.MultipartFile> files = <http.MultipartFile>[];
  //   if (imageFile != null) {
  //     final String fileName = imageFile.path.split('/').last;
  //     final http.MultipartFile image =
  //         await http.MultipartFile.fromPath('ImageFile', imageFile.path);
  //     files.add(image);
  //     fields['ImageFile'] = fileName;
  //   }

  //   try {
  //     final http.MultipartRequest request =
  //         http.MultipartRequest('PUT', Uri.parse(url))
  //           ..headers.addAll(headers)
  //           ..fields.addAll(fields)
  //           ..files.addAll(files);

  //     final http.StreamedResponse response = await request.send();

  //     if (response.statusCode == 200) {
  //       _isSentSuccessfully = true;
  //     } else {
  //     _errorMessage = 'Something went wrong!\nPlease try again later.';
  //       _isSentSuccessfully = false;
  //     }
  //   } catch (error) {
  //     _errorMessage = error.toString();
  //     _isSentSuccessfully = false;
  //   } finally {
  //     notifyListeners();
  //   }
  // }

  Future<void> fetchProfileData(
    String driverId,
  ) async {
    _isLoading = true;
    _errorMessage = '';

    try {
      Uri uri = Uri.https("admin.noomitransport.com",
          "api/AccountService/GetAccountByIdv1", {"DriverId": driverId});
      final response = await http.get(uri, headers: {
        "FROM": "Noomi",
        "DriverID": driverId,
      });

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        _profile = ProfileM.fromJson(jsonData);
      } else {
        _errorMessage =
            'hey!It seems that either there is a problem with the server,\nOr your acount is not available';
      }
    } catch (error) {
      _errorMessage =
          'It seems that either there is a problem with the server,\nOr your acount is not available';
    }
    setProfileData();
    print('profile imageeeeeeeeeeeeeeeeeeeeeeeeeeellllllllllllllllllll:' +
        _profile.profileImage);
    _isLoading = false;
    notifyListeners();
  }

  String getStateName(
    int caseNumber,
  ) {
    String stateName;
    switch (caseNumber) {
      case -1:
        stateName = "None";
        break;
      case 0:
        stateName = "Alabama";
        break;
      case 1:
        stateName = "Alaska";
        break;
      case 2:
        stateName = "Arizona";
        break;
      case 3:
        stateName = "Arkansas";
        break;
      case 4:
        stateName = "California";
        break;
      case 5:
        stateName = "Colorado";
        break;
      case 6:
        stateName = "Connecticut";
        break;
      case 7:
        stateName = "Delaware";
        break;
      case 8:
        stateName = "Florida";
        break;
      case 9:
        stateName = "Georgia";
        break;
      case 10:
        stateName = "Hawaii";
        break;
      case 11:
        stateName = "Idaho";
        break;
      case 12:
        stateName = "Illinois";
        break;
      case 13:
        stateName = "Indiana";
        break;
      case 14:
        stateName = "Iowa";
        break;
      case 15:
        stateName = "Kansas";
        break;
      case 16:
        stateName = "Kentucky";
        break;
      case 17:
        stateName = "Louisiana";
        break;
      case 18:
        stateName = "Maine";
        break;
      case 19:
        stateName = "Maryland";
        break;
      case 20:
        stateName = "Massachusetts";
        break;
      case 21:
        stateName = "Michigan";
        break;
      case 22:
        stateName = "Minnesota";
        break;
      case 23:
        stateName = "Mississippi";
        break;
      case 24:
        stateName = "Missouri";
        break;
      case 25:
        stateName = "Montana";
        break;
      case 26:
        stateName = "Nebraska";
        break;
      case 27:
        stateName = "Nevada";
        break;
      case 28:
        stateName = "New Hampshire";
        break;
      case 29:
        stateName = "New Jersey";
        break;
      case 30:
        stateName = "New Mexico";
        break;
      case 31:
        stateName = "New York";
        break;
      case 32:
        stateName = "North Carolina";
        break;
      case 33:
        stateName = "North Dakota";
        break;
      case 34:
        stateName = "Ohio";
        break;
      case 35:
        stateName = "Oklahoma";
        break;
      case 36:
        stateName = "Oregon";
        break;
      case 37:
        stateName = "Pennsylvania";
        break;
      case 38:
        stateName = "Rhode Island";
        break;
      case 39:
        stateName = "South Carolina";
        break;
      case 40:
        stateName = "South Dakota";
        break;
      case 41:
        stateName = "Tennessee";
        break;
      case 42:
        stateName = "Texas";
        break;
      case 43:
        stateName = "Utah";
        break;
      case 44:
        stateName = "Vermont";
        break;
      case 45:
        stateName = "Virginia";
        break;
      case 46:
        stateName = "Washington";
        break;
      case 47:
        stateName = "West_Virginia";
        break;
      case 48:
        stateName = "Wisconsin";
        break;
      case 49:
        stateName = "Wyoming";
        break;
      default:
        stateName = "select state";
    }
    return stateName;
  }
}
