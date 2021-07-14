import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:covid_app/models/quarantine_item.dart';
import 'package:covid_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  static const base_url = 'covid-app-b1807-default-rtdb.firebaseio.com';
  UserData _user = UserData();
  String? _token;
  DateTime? _expiryDate;
  Timer? _authTimer;
  String? _refreshToken;
  bool get isAuth {
    return _token != null && _user.type != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null &&
        _refreshToken != null) {
      return _token;
    }
    return null;
  }

  UserData? get user {
    return _user;
  }

  Future<void> login(
    String email,
    String password,
  ) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> signup(String email, String password,
      {UserData? userData}) async {
    return _authenticate(
      email,
      password,
      'signUp',
      userData: userData,
    );
  }

  Future<void> _authenticate(String email, String password, String urlSegment,
      {UserData? userData}) async {
    var uri = Uri.https(
      'identitytoolkit.googleapis.com',
      'v1/accounts:$urlSegment',
      {'key': 'AIzaSyBWoX4qrpjEHIaP-wbYBsfdI2iiUGx3h0I'},
    );
    try {
      final response = await http.post(
        uri,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      print('auth err1: ${response.body}');

      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (responseData['error'] != null) {
        print('auth err: $responseData');
        throw HttpException(responseData['error']['message']);
      }
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      print('exp date: $_expiryDate');
      _token = responseData['idToken'];
      _user.id = responseData['localId'];
      _refreshToken = responseData['refreshToken'];
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userJsonData = json.encode({
        'email': email,
        'token': _token,
        'userId': _user.id,
        'refresh_token': _refreshToken,
        'expiryDate': _expiryDate!.toIso8601String(),
      });
      print('userData: $userJsonData');
      prefs.setString('userData', userJsonData);
      if (urlSegment == 'signUp') {
        await _saveUserData(
          userData!,
        );
      } else {
        await getUserData();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> _refreshSession() async {
    try {
      final response = await http.post(
        Uri.https(
          'securetoken.googleapis.com',
          'v1/token',
          {'key': 'AIzaSyBWoX4qrpjEHIaP-wbYBsfdI2iiUGx3h0I'},
        ),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: {
          'grant_type': 'refresh_token',
          'refresh_token': _refreshToken,
        },
      );
      final responseData = json.decode(response.body);
      print('RefreshSession: $responseData');
      if (responseData['error'] != null) {
        await logout();
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['id_token'];
      _refreshToken = responseData['refresh_token'];
      _user.id = responseData['user_id'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expires_in'])));
      notifyListeners();
      _autoLogout();
      await getUserData();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'refresh_token': _refreshToken,
        'userId': _user.id,
        'expiryDate': _expiryDate!.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (error) {
      await logout();
      throw error;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _token = null;
    _refreshToken = null;
    _expiryDate = null;
    _user = UserData();

    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    print('timeToExpiry: $timeToExpiry');
    _authTimer = Timer(
      Duration(seconds: timeToExpiry),
      _refreshSession,
    );
  }

  Future<void> _saveUserData(
    UserData newUserData,
  ) async {
    var uri = Uri.https(base_url, 'users/${_user.id}.json', {'auth': _token});
    final timestamp = DateTime.now();
    try {
      final response = await http.put(
        uri,
        body: json.encode({
          'userType': newUserData.type,
          'joinTime': timestamp.toIso8601String(),
          'fullname': newUserData.name,
          'email': newUserData.email,
        }),
      );
      print('save user data: ${response.body}');
      if (response.statusCode == 200) {
        _user.name = newUserData.name;
        _user.email = newUserData.email;
        _user.type = newUserData.type;
        notifyListeners();
      }
    } catch (err) {
      throw err;
    }
  }

  Future<bool> savePatientProfile(
    UserData newUserData,
  ) async {
    var uri = Uri.https(base_url, 'users/${_user.id}.json', {'auth': _token});
    try {
      final response = await http.put(
        uri,
        body: json.encode({
          'userType': newUserData.type,
          'joinTime': newUserData.joinDate,
          'fullname': newUserData.name,
          'email': newUserData.email,
          'location': {
            'location': newUserData.location,
            'lati': newUserData.lati,
            'longi': newUserData.longi,
          },
          'current_location': {
            'location': newUserData.currentLocation,
            'lati': newUserData.currentLati,
            'longi': newUserData.currentLongi,
          },
          'phone': newUserData.phone,
          'gender': newUserData.gender,
          'blood_type': newUserData.bloodType,
          'age': newUserData.age,
          'occupation': newUserData.occupation,
          'vaccinated': newUserData.vaccinated,
          'vaccine_data': newUserData.vaccineData == null
              ? null
              : {
                  'dose': newUserData.vaccineData!.dose,
                  'dateOfVaccination':
                      newUserData.vaccineData!.dateOfVaccination,
                  'vaccineType': newUserData.vaccineData!.vaccineType,
                },
        }),
      );
      if (response.statusCode >= 400) {
        return false;
      }
      print('save user profile: ${response.body}');
      await getUserData();
      return true;
    } catch (err) {
      throw err;
    }
  }

  Future<void> getUserData() async {
    print('getUserData');
    var uri = Uri.https(base_url, 'users/${_user.id}.json', {'auth': _token});
    try {
      final response = await http.get(uri);
      print('userInfo: ${response.body}');
      if (response.body == 'null') {
        return;
      }
      final data = json.decode(response.body) as Map<String, dynamic>;
      _user.email = data['email'];
      _user.type = data['userType'];
      _user.name = data['fullname'];
      _user.location =
          data['location'] != null ? data['location']['location'] : null;
      _user.lati = data['location'] != null ? data['location']['lati'] : null;
      _user.longi = data['location'] != null ? data['location']['longi'] : null;
      _user.currentLocation = data['current_location'] != null
          ? data['current_location']['location']
          : null;
      _user.currentLati = data['current_location'] != null
          ? data['current_location']['lati']
          : null;
      _user.currentLongi = data['current_location'] != null
          ? data['current_location']['longi']
          : null;
      _user.age = data['age'];
      _user.bloodType = data['blood_type'];
      _user.phone = data['phone'];
      _user.gender = data['gender'];
      _user.occupation = data['occupation'];
      _user.joinDate = data['joinTime'];
      _user.vaccinated = data['vaccinated'] ?? false;
      _user.vaccineData = data['vaccine_data'] == null
          ? null
          : VaccineData(
              dose: data['vaccine_data']['dose'],
              dateOfVaccination: data['vaccine_data']['dateOfVaccination'],
              vaccineType: data['vaccine_data']['vaccineType'],
            );
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      _refreshToken = extractedUserData['refresh_token'];
      await _refreshSession();
      return false;
    }
    _user.email = extractedUserData['email'];
    _token = extractedUserData['token'];
    _refreshToken = extractedUserData['refresh_token'];
    _user.id = extractedUserData['userId'];
    _expiryDate = expiryDate;

    notifyListeners();
    await getUserData();
    _autoLogout();
    return true;
  }

  Future<void> addQuarantineItem(QuarantineItem item) async {
    if (_user.type != 'Patient') {
      return;
    }
    var uri = Uri.https(
      base_url,
      'quarantine/${_user.id}.json',
      {'auth': _token},
    );
    try {
      final response = await http.post(
        uri,
        body: json.encode({
          'date': item.date,
          'isHome': item.isHome,
          'latitude': item.latitude,
          'location': item.location,
          'longitude': item.longitude,
        }),
      );
      print('${response.body}');
    } catch (err) {
      throw err;
    }
  }

  Future<void> setUserCurrentLocation({
    required String location,
    required String lati,
    required String longi,
  }) async {
    if (_user.id == null) {
      return;
    }
    _user.currentLocation = location;
    _user.currentLati = lati;
    _user.currentLongi = longi;
    notifyListeners();
    var uri = Uri.https(
      base_url,
      'users/${_user.id}/current_location.json',
      {'auth': _token},
    );
    try {
      final response = await http.put(
        uri,
        body: json.encode({
          'location': location,
          'lati': lati,
          'longi': longi,
        }),
      );
      print('save user location: ${response.body}');

      addQuarantineItem(
        QuarantineItem(
          date: DateFormat.yMMMd().add_jm().format(DateTime.now()),
          isHome: Geolocator.distanceBetween(
                double.parse(_user.currentLati ?? '0.0'),
                double.parse(_user.currentLongi ?? '0.0'),
                double.parse(_user.lati ?? '0.0'),
                double.parse(_user.longi ?? '0.0'),
              ) <=
              20,
          latitude: lati,
          location: location,
          longitude: longi,
        ),
      );
    } catch (err) {
      print('error: $err');
      throw err;
    }
  }
}
