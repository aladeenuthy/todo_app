import 'dart:async';
import 'dart:convert';
import '/helpers/db_helper.dart';
import '/models/http_exeption.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  String? _refreshToken;

  String? get token {
    return _token;
  }
  DateTime? get expiryDate {
    return _expiryDate;
  }
  String? get userId {
    return _userId;
  }
  bool get isAuth {
    return token != null;
  }
  Future<bool> tryAutLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData') as String)
        as Map<String, dynamic>;
    _token = extractedUserData['token'];
    _expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    _userId = extractedUserData['userId'];
    _refreshToken = extractedUserData['refreshToken'];
    notifyListeners();
    return true;
  }
  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    try {
      final url =
          "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=webKey";
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _refreshToken = responseData['refreshToken'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'expiryDate': _expiryDate!.toIso8601String(),
        'userId': _userId,
        'refreshToken': _refreshToken
      });
      prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }
  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }
  Future<void> login(
    String email,
    String password,
  ) async {
    return _authenticate(email, password, "signInWithPassword");
  }
  Future<void> logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    _refreshToken = null;
    await DBHelper.wipeData();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }
  Future<void> refreshSession() async {
    const url =
        'https://securetoken.googleapis.com/v1/token?key=webKey';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: 'grant_type=refresh_token&refresh_token=$_refreshToken',
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['id_token'];
      _refreshToken = responseData['refresh_token'];
      _userId = responseData['user_id'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expires_in'])));
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'refreshToken': _refreshToken,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (_) {}
  }
  Future<dynamic> getOrRefreshToken() async {
    if (_expiryDate!.isAfter(DateTime.now())) {
      return _token;
    }
    await refreshSession();
    return _token;
  }
}
