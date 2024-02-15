import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeliveryInfoProv extends ChangeNotifier {
  int _tripId = 0;
  String? _clientFullName = '';
  String? _notes = '';
  bool _isOverridden = false;
  File? _signatureImage;
  bool _isSignatureSaved = false;
  String _errorMessage = '';
  bool _isSentSuccessfully = false;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool get isSentSuccessfully => _isSentSuccessfully;
  String get errorMessage => _errorMessage;
  bool get isSignatureSaved => _isSignatureSaved;

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> sendDeliveryInfo({
    required String driverId,
    required int tripId,
    required int tripStatus,
    bool isOverridden = false,
    String? note,
    String? guardianFullName,
    File? signatureImage,
  }) async {
    try {
      String url =
          'https://admin.noomitransport.com/api/TripService/UpdateTripstatusv1?DriverId=$driverId&TripId=$tripId&status=$tripStatus&delivery';

      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers
          .addAll({'Content-Type': 'multipart/form-data', "FROM": "Noomi","DriverID":driverId});

      request.fields['IsSignatureOverridden'] = isOverridden.toString();
      request.fields['GuardianFullName'] = guardianFullName ?? '';
      request.fields['Note'] = note ?? '';

      if (signatureImage != null) {
        final filePart = http.MultipartFile(
          'GuardianSignatureFile',
          signatureImage.readAsBytes().asStream(),
          signatureImage.lengthSync(),
          filename: 'signature${DateTime.now()}.jpg',
        );
        request.files.add(filePart);
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        _isSentSuccessfully = true;
      } else {
        _errorMessage = 'Something went wrong!\nPlease try again later.';
        _isSentSuccessfully = false;
      }
    } catch (error) {
      _errorMessage = error.toString();
      _isSentSuccessfully = false;
    }
    _isLoading = false;
    notifyListeners();
  }

  void setIsSignatureSaved(bool value) {
    _isSignatureSaved = value;
    notifyListeners();
  }

  int get tripId => _tripId;
  String get clientFullName => _clientFullName ?? '';
  String get notes => _notes ?? '';
  bool get isOverridden => _isOverridden;
  File? get signatureImage => _signatureImage;

  void setTripId(int value) {
    _tripId = value;
    notifyListeners();
  }

  void setClientFullName(String value) {
    _clientFullName = value;
    notifyListeners();
  }

  void setNotes(String value) {
    _notes = value;
    notifyListeners();
  }

  void setIsOverridden(bool value) {
    _isOverridden = value;
    notifyListeners();
  }

  void setSignatureImage(Uint8List? value) {
    if (value == null) {
      _signatureImage = null;
    } else {
      _signatureImage =
          uint8ListToFile(value, 'signature${DateTime.now()}.jpg');
    }

    notifyListeners();
  }

  File uint8ListToFile(Uint8List data, String fileName) {
    Directory tempDir = Directory.systemTemp;
    File tempFile = File('${tempDir.path}/$fileName');
    tempFile.writeAsBytesSync(data);
    return tempFile;
  }
}
