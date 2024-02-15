import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CheckListProv with ChangeNotifier {
  List<dynamic> _checkListElements = [];
  bool _isAllChecked = false;
  bool _isCheckListComplete = false;
  List<bool> _isElementsChecked = [];
  String savedDate = '';
  String _errorMessage = '';
  bool _isLoading = false;

  List<dynamic> get checkListElements => _checkListElements;
  isAllChecked() => _isAllChecked;
  isCheckListComplete() => _isCheckListComplete;
  bool isElementsChecked(int index) => _isElementsChecked[index];
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  void setIsElementsChecked(int index, bool value) {
    _isElementsChecked[index] = value;
    checkIsAllChecked();
    notifyListeners();
  }

  void checkIsAllChecked() {
    bool tempBool = true;
    for (int i = 0; i < _checkListElements.length; i++) {
      tempBool &= _isElementsChecked[i];
    }
    _isAllChecked = tempBool;
    notifyListeners();
  }

  void toggleCheckAll() {
    _isAllChecked = !_isAllChecked;
    notifyListeners();
    for (int i = 0; i < _isElementsChecked.length; i++) {
      _isElementsChecked[i] = _isAllChecked;
    }
    notifyListeners();
  }

  void setIsCheckListComplete() {
    _isCheckListComplete = _isAllChecked;
    notifyListeners();
  }

  Future<void> saveIsCheckListComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isCheckListComplete', _isCheckListComplete);
  }

  Future<void> loadIsCheckListComplete() async {
    final prefs = await SharedPreferences.getInstance();
    _isCheckListComplete = prefs.getBool('_isCheckListComplete') ?? false;
    notifyListeners();
  }

  Future<void> saveDate() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final dateString = '${now.year}-${now.month}-${now.day}';
    await prefs.setString('date', dateString);
  }

  Future<void> loadDate() async {
    final prefs = await SharedPreferences.getInstance();
    savedDate = prefs.getString('date') ?? '';
  }

  void CompareDates() {
    DateTime now = DateTime.now();
    final currentDate = '${now.year}-${now.month}-${now.day}';
    if (savedDate == currentDate) {
      _isCheckListComplete = true;
    } else {
      _isCheckListComplete = false;
    }
    notifyListeners();
  }

  Future<void> fetchCheckList({required String driverId}) async {
    _isLoading = true;

    _checkListElements.addAll(await getCheckList(driverId: driverId));
    for (int i = 0; i < _checkListElements.length; i++) {
      _isElementsChecked.add(false);
      notifyListeners();
    }
    _isLoading = false;

    notifyListeners();
  }

  Future<List<dynamic>> getCheckList({required String driverId}) async {
    _errorMessage = '';
    try {
      final response = await http.get(
          Uri.parse(
              'https://admin.noomitransport.com/api/CheckListService/GetCheckListv1'),
          headers: {"FROM": "Noomi","DriverID":driverId});

      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        List temp = [];
        for (var item in data['\$values']) {
          temp.add(item);
        }
        return temp;
      } else {
        _errorMessage =
            'It seems that either there is a problem with the server,\nOr your acount is not available';
        return [];
      }
    } catch (e) {
      _errorMessage =
          'It seems that either there is a problem with the server,\nOr your acount is not available';
      return [];
    }
  }
}
