import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PhoneProv extends ChangeNotifier {
  bool _isPhoneNumberExists = false;
  bool _isAccountActive = false;
  bool isLoading = false;
  bool _isVerifying = false;
  bool _isAccountAvailable = false;
  bool get isAccountAvailable => _isAccountAvailable;
  String? _driverId;
  bool _isSignedIn = false;
  String? get driverId => _driverId;
  bool get isPhoneNumberExists => _isPhoneNumberExists;
  bool get isAccountActive => _isAccountActive;
  bool get isVreifying => _isVerifying;
  bool get isSignedIn => _isSignedIn;

  void setIsSignedIn(bool value) {
    _isSignedIn = value;
    notifyListeners();
  }

  void setIsAccountAvailable(bool value) {
    _isAccountAvailable = value;
    notifyListeners();
  }

  void setIsVerifying(bool value) {
    _isVerifying = value;
    notifyListeners();
  }

/////////////////////////////// here I have to put the new api get call to send the username and pass and get either succes or not by true or false

  Future<void> signIn({required String email, required String password}) async {
    try {
      String url =
          'https://admin.noomitransport.com/api/AccountService/LogIn?Email=$email&Password=$password';

      var headers = {
        'FROM': 'Noomi',
      };

      var response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        bool signInResult = json.decode(response.body);

        _isSignedIn = signInResult;
        notifyListeners();
      } else {
        _isSignedIn = false;
        notifyListeners();
      }
    } catch (e) {
      _isSignedIn = false;
      notifyListeners();
    }
  }

  // we will live this api call as it is because we don't have firebaseUID and phoneNumber
  Future<void> checkAccountAvailability() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://admin.noomitransport.com/api/AccountService/AvailableAccount?DriverID=$_driverId'),
        headers: {'FROM': 'Noomi'},
      );
      final responseBody = jsonDecode(response.body);
      _isAccountAvailable = responseBody;
    } catch (e) {
      _isAccountAvailable = false;
    }
    notifyListeners();
  }

  Future<bool> checkPhoneNumberExistence(String email) async {
    try {
      // here will change phone number to email
      final response = await http.get(
        Uri.parse(
            'https://admin.noomitransport.com/api/AccountService/GetAccountv1?Email=$email'),
        headers: {'FROM': 'Noomi'},
      );
      final responseBody = jsonDecode(response.body);
      _driverId = responseBody['Id'];
      await saveDriverId(responseBody['Id']);
      _isPhoneNumberExists = responseBody['Id'] != null;
      notifyListeners();
      return _isPhoneNumberExists;
    } catch (e) {
      return false;
    }
  }

  Future<void> saveDriverId(String driverId) async {
    _driverId = driverId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('driverId', driverId);
    notifyListeners();
  }

  Future<void> loadDriverId(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    _driverId = prefs.getString('driverId').toString();
    print('idddddddddddddddddd: ' + _driverId.toString());
    notifyListeners();
  }

  Future<bool> validateAccount(String email) async {
    try {
      // this was to make sure if the account is active
      final response = await http.get(
        Uri.parse(
            'https://admin.noomitransport.com/api/AccountService/AccountValidationv1?Email=$email'),
        headers: {'FROM': 'Noomi'},
      );
      final responseBody = jsonDecode(response.body);
      _isAccountActive = responseBody;
      notifyListeners();
      return _isAccountActive;
    } catch (e) {
      return false;
    }
  }
}
