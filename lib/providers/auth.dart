import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:covid_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
      {Map<String, String>? userData}) async {
    return _authenticate(
      email,
      password,
      'signUp',
      userData: userData,
    );
  }

  Future<void> _authenticate(String email, String password, String urlSegment,
      {Map<String, String>? userData}) async {
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
          email,
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
    _token = null;
    _user.id = null;
    _refreshToken = null;
    _expiryDate = null;

    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    _user.name = null;
    _user.type = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
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

  Future<void> _saveUserData(Map<String, String> userData, String email) async {
    var uri = Uri.https(base_url, 'users/${_user.id}.json', {'auth': _token});
    final timestamp = DateTime.now();
    try {
      final response = await http.put(
        uri,
        body: json.encode({
          'userType': userData['type'],
          'joinTime': timestamp.toIso8601String(),
          'fullname': userData['fullname'],
          'email': email,
        }),
      );
      print('save user data: ${response.body}');
      _user.type = userData['type'];
      _user.name = userData['fullname'];
      _user.email = email;
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
      final data = json.decode(response.body) as Map<String, dynamic>;
      _user.email = data['email'];
      _user.type = data['userType'];
      _user.name = data['fullname'];
      _user.location =
          data['location'] != null ? data['location']['location'] : null;
      _user.lati = data['location'] != null ? data['location']['lati'] : null;
      _user.longi = data['location'] != null ? data['location']['longi'] : null;
      // _user.photo = data['photo'];
      // _user.phone = data['phone'];
      // _user.bio = data['bio'];
      // _user.approved = data['approved'] ?? false;
      // _user.gender = data['gender'] ?? 'UNKNOWN';
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

  Future<void> setUserLocation({
    required String location,
    required String lati,
    required String longi,
  }) async {
    if (_user.id == null) {
      return;
    }
    _user.location = location;
    _user.lati = lati;
    _user.longi = longi;
    notifyListeners();
    var uri = Uri.https(
      base_url,
      'users/${_user.id}/location.json',
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
    } catch (err) {
      print('error: $err');
      throw err;
    }
  }
}
