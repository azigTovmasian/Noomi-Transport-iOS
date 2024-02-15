import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../Models/trip_m.dart';

class TripProv with ChangeNotifier {
  TripM? _trip;
  List<TripM> _trips = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String _tripDetailErrorMessage = '';
  DateTime _currentDate = DateTime.now();
  String _pickUpOrDropOff = 'PickUp';
  bool _isCondition = false;
  bool _canGoBack = true;
  bool _canGoForward = true;
  bool _isSentSuccessfully = false;
  bool _isPreviousDayTripsCompleted = true;
  bool _isTomorrow = false;
  String _nommiAdminPhoneNumber = '';

  String get noomiAdminPhoneNumber => _nommiAdminPhoneNumber;
  bool get isTomorrow => _isTomorrow;
  bool get isPreviousDayTripsCompleted => _isPreviousDayTripsCompleted;
  bool get isSentSuccessfully => _isSentSuccessfully;
  bool get canGoBack => _canGoBack;
  bool get canGoForward => _canGoForward;
  String get pickUpOrDropOff => _pickUpOrDropOff;
  bool get isCondition => _isCondition;
  String get tripDetailErrorMessage => _tripDetailErrorMessage;
  TripM? get trip => _trip;

  void updateCanGoBack(bool canGoBack) {
    _canGoBack = canGoBack;
    notifyListeners();
  }

  void updateCanGoForward(bool canGoForward) {
    _canGoForward = canGoForward;
    notifyListeners();
  }

  void setPickUpOrDropOff() {
    _pickUpOrDropOff = _trip!.status == 1 //'started'
        ? 'PickUp'
        : 'DropOff';
    notifyListeners();
  }

  DateTime get currentDate => _currentDate;

  void setStatus({required int index, required int value}) {
    _trips[index].status = value;

    notifyListeners();
  }

  void setCurrentDate(DateTime date) {
    _currentDate = date;
    notifyListeners();
  }

  List<TripM> get trips => _trips;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void checkIfSelectedDateIsOneDayAfterCurrentDate() {
    DateTime todaysDate = DateTime.now();
    DateTime tomorrowDate = todaysDate.add(Duration(days: 1));

    if (_currentDate.year == tomorrowDate.year &&
        _currentDate.month == tomorrowDate.month &&
        _currentDate.day == tomorrowDate.day) {
      _isTomorrow = true;
      notifyListeners();
    } else {
      _isTomorrow = false;
      notifyListeners();
    }
  }

  Future<void> fetchTrips(
      {required BuildContext context,
      required String driverId,
      }) async {
    _isLoading = true;
    _errorMessage = '';

    try {
      Uri uri = Uri.https(
          "admin.noomitransport.com",
          "api/TripService/DriverTripsv1",
          {"DriverId": driverId, "TripDate": "${_currentDate}"});
      final response = await http
          .get(uri, headers: {"FROM": "Noomi",
           "DriverID": driverId
          });

      if (response.statusCode == 200) {
        _trips.clear();
        final jsonData = jsonDecode(response.body);

        if (jsonData is List<dynamic>) {
          _trips.addAll(
              await jsonData.map((trip) => TripM.fromJson(trip)).toList());
               _trips.sort((a, b) => a.pickupTime.compareTo(b.pickupTime)); //new added
        } else if (jsonData is Map<String, dynamic>) {
          final jsonData =
              jsonDecode(response.body)['\$values'] as List<dynamic>;
          _trips.addAll(jsonData.map((trip) => TripM.fromJson(trip)).toList());
          _trips.sort((a, b) => a.pickupTime.compareTo(b.pickupTime));
        }
      } else {
        _trips.clear();
        _errorMessage =
            'It seems that either there is a problem with the server,\nOr your acount is not available';
      }
    } catch (error) {
      _trips.clear();

      _errorMessage =
          'It seems that either there is a problem with the server,\nOr your acount is not available';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchPerviousDayTrips(
      {required BuildContext context,
      required String driverId,
      }) async {
    try {
      List<TripM> tempTrips = [];
      tempTrips.clear();
      _errorMessage = '';

      Uri uri =
          Uri.https("admin.noomitransport.com", "api/TripService/DriverTripsv1", {
        "DriverId": driverId,
        "TripDate": "${DateTime.now().subtract(Duration(days: 1))}"
      });
      final response = await http
          .get(uri, headers: {"FROM": "Noomi", 
          "DriverID": driverId
          });
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData is List<dynamic>) {
          tempTrips.addAll(
              await jsonData.map((trip) => TripM.fromJson(trip)).toList());
        } else if (jsonData is Map<String, dynamic>) {
          final jsonData =
              jsonDecode(response.body)['\$values'] as List<dynamic>;
          tempTrips
              .addAll(jsonData.map((trip) => TripM.fromJson(trip)).toList());

          if (tempTrips.isNotEmpty) {
            hasTripsWithStatus(tempTrips);
            if (!_isPreviousDayTripsCompleted) {
              showAlertDialog(context);
            }
          }
        }
      } else {
        _errorMessage =
            'It seems that either there is a problem with the server,\nOr you may be experiencing a poor internet connection';
      }
    } catch (error) {
      _errorMessage =
          'It seems that either there is a problem with the server,\nOr you may be experiencing a poor internet connection';
    }
    notifyListeners();
  }

  Future<void> fetchNoomiAdminPhoneNumber(
    { required String driverId }
    ) async {
    try {
      _isLoading = true;
      _nommiAdminPhoneNumber = '';

      Uri uri = Uri.https(
        "admin.noomitransport.com",
        "api/AccountService/ContactNoomiAdminv1",
      );
      final response = await http
          .get(uri, headers: {"FROM": "Noomi",
           "DriverID": driverId
           });
      if (response.statusCode == 200) {
        _nommiAdminPhoneNumber =
            response.body.replaceAll("\\u002B", '+').replaceAll('"', '');
      } else {
        _nommiAdminPhoneNumber = '';
      }
    } catch (error) {
      _nommiAdminPhoneNumber = '';
    }
    notifyListeners();
  }

  showAlertDialog(
    BuildContext context,
  ) {
    AlertDialog alert = AlertDialog(
      title: Text("Contact Noomi Admins"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'There are some incomplete trips for past days.  Please contact Noomi Admins to complete these past trips so you can continue with today\’s trips.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Center(
            child: GestureDetector(
              onTap: () {
                launchUrl(Uri.parse("tel:${_nommiAdminPhoneNumber}"));
              },
              child: Text(
                _nommiAdminPhoneNumber,
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Color(0xff7CA03E)),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text(
            "OK",
            style: TextStyle(
              color: Color(0xff7CA03E),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void hasTripsWithStatus(List<TripM> trips) {
    bool containsIncompleteTrips = false;
    for (final trip in trips) {
      if (trip.status != null && [0, 1, 2].contains(trip.status)) {
        containsIncompleteTrips = true;
        break;
      }
    }
    _isPreviousDayTripsCompleted = !containsIncompleteTrips;
    notifyListeners();
  }

  Future<void> fetchOneTrip(BuildContext context,
      {required int tripId,
      required String driverId,
      }) async {
    _isLoading = true;
    _tripDetailErrorMessage = '';
    try {
      final String uri =
          'https://admin.noomitransport.com/api/TripService/GetTripv1?DriverId=$driverId&id=${tripId.toString()}';
      final response = await http.get(Uri.parse(uri),
          headers: {"FROM": "Noomi", "DriverID": driverId});

      if (response.statusCode == 200) {
        final jsonData =
            await jsonDecode(response.body) as Map<String, dynamic>;
        _trip = TripM.fromJson(jsonData);
        notifyListeners();
      } else {
        _tripDetailErrorMessage =
            'It seems that either there is a problem with the server,\nOr you may be experiencing a poor internet connection';
      }
    } catch (error) {
      _tripDetailErrorMessage =
          'It seems that either there is a problem with the server,\nOr you may be experiencing a poor internet connection';
    }
    _isLoading = false;
    notifyListeners();
  }

  bool stateCondition({required int index}) {
    bool isCondition;
    isCondition = (index == 0
        ? (_trips[index].status == 0) //'initiated'
        : ((_trips[index - 1].status == 4 || // 'completed'
                _trips[index - 1].status == 3 || // 'no show'
                _trips[index - 1].status == 5) && //  'canceled'
            (_trips[index].status == 0))); //'initiated'
    print("conditionnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn$isCondition");
    return isCondition;
  }

  bool isTripCardClickable(
      {required bool isCheckListComplete, required int index}) {
    bool condition = false;
    condition = currentDate.isAtSameMomentAs(DateTime.now())
        ? ((_isPreviousDayTripsCompleted) &&
            (isCheckListComplete) &&
            ((index == 0) ||
                ((index != 0) &&
                    (_trips[index - 1].status == 5 ||
                        _trips[index - 1].status == 4 ||
                        _trips[index - 1].status == 3))))
        : currentDate.isBefore(DateTime.now())
            ? (_isPreviousDayTripsCompleted)
            : false;
    return condition;
  }

  String convertStatus2String(int? value) {
    String status;
    switch (value) {
      case 0:
        status = "initiated";
        break;
      case 1:
        status = "Started";
        break;
      case 2:
        status = "In Progress";
        break;
      case 3:
        status = "No Show";
        break;
      case 4:
        status = "Completed";
        break;
      case 5:
        status = "Canceled";
        break;
      default:
        status = "initiated";
        break;
    }
    return status;
  }
}
