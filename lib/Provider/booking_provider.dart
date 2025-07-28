import 'package:flutter/material.dart';

class BookingProvider extends ChangeNotifier {
  String _stageName = '';
  String _stageImageUrl = '';
  String _date = '';
  String _packageName = '';
  String _price = '';
  String _status = '';

  String get stageName => _stageName;
  String get stageImageUrl => _stageImageUrl;
  String get date => _date;
  String get packageName => _packageName;
  String get price => _price;
  String get status => _status;

  void setBookingDetails({
    required String stageName,
    required String stageImageUrl,
    required String date,
    required String packageName,
    required String price,
    required String status,
  }) {
    _stageName = stageName;
    _stageImageUrl = stageImageUrl;
    _date = date;
    _packageName = packageName;
    _price = price;
    _status = status;
    notifyListeners();
  }
}
