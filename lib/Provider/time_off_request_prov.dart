import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Models/time_off_request_m.dart';

class TimeOffRequestProv with ChangeNotifier {
  String _request = '';
  String _noRequest = '';

  bool _isLoading = false;
  TimeOffRequestM _timeOffRequest =
      TimeOffRequestM(status: 0, updatedAt: DateTime.now());
  TimeOffRequestM get timeOffRequest => _timeOffRequest;
  String get request => _request;
  String get noRequest => _noRequest;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  void setIsLoading(bool value) {
    _isLoading = value;

    notifyListeners();
  }

  void sendTimeOffRequestInfo(String timeOffRequestValue, String driverId,
    ) async {
    var url =
        'https://admin.noomitransport.com/api/TimeOffService/CreateTimeoffRequestv1';

    try {
      await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          "FROM": "Noomi",
          "DriverID": driverId
        },
        body:
            jsonEncode({"TimeOfRequest": timeOffRequestValue, "AccountID": driverId}),
      );
      notifyListeners();
    } catch (error) {}
  }

  Future<void> fetchPTimeOffRequestRespond(String driverId,
      ) async {
    _isLoading = true;
    _errorMessage = '';
    _noRequest = '';

    try {
      Uri uri = Uri.https(
          "admin.noomitransport.com", "api/TimeOffService/GetLastRequestv1", {
        "Id": driverId,
      });
      final response = await http
          .get(uri, headers: {"FROM": "Noomi", "DriverID": driverId});
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        _timeOffRequest = TimeOffRequestM.fromJson(jsonData);
      } else if (response.statusCode == 400) {
        _noRequest = 'FYI - You don\'t Have any time off requests';
        notifyListeners();
      } else {
        _errorMessage =
            'It seems that either there is a problem with the server,\nOr your acount is not available';
      }
    } catch (error) {
      _errorMessage =
          'It seems that either there is a problem with the server,\nOr your acount is not available';
    }
    _isLoading = false;
    notifyListeners();
  }
}
