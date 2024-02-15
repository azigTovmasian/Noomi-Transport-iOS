import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityProv with ChangeNotifier {
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  bool _isThereInternet = false;

  ConnectivityProv() {
    Connectivity().onConnectivityChanged.listen(_updateConnectivityResult);
  }

  ConnectivityResult get connectivityResult => _connectivityResult;
  bool get isThereInternet => _isThereInternet;

  void _updateConnectivityResult(ConnectivityResult result) {
       _connectivityResult = result;
    _isThereInternet = result != ConnectivityResult.none;   
    notifyListeners();
  }
}
