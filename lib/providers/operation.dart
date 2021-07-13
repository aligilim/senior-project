import 'package:flutter/material.dart';

class Operation with ChangeNotifier {
  static const base_url = 'covid-app-b1807-default-rtdb.firebaseio.com';
  String? _authToken;
  set authToken(String? value) {
    _authToken = value;
  }
}
