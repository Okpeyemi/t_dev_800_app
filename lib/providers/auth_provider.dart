import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String _username = '';
  String _email = '';

  bool get isLoggedIn => _isLoggedIn;
  String get username => _username;
  String get email => _email;

  Future<bool> login(String email, String password) async {
    // Here you would implement actual authentication
    // For now, just simulating a successful login
    _isLoggedIn = true;
    _email = email;
    _username = email.split('@')[0]; // Just using part of email as username
    
    // Save login state
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('username', _username);
    await prefs.setString('email', _email);
    
    notifyListeners();
    return true;
  }

  Future<bool> register(String email, String password, String username) async {
    // Here you would implement actual registration
    // For now, just simulating a successful registration
    _isLoggedIn = true;
    _email = email;
    _username = username;
    
    // Save login state
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('username', _username);
    await prefs.setString('email', _email);
    
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _username = '';
    _email = '';
    
    // Clear login state
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    notifyListeners();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (_isLoggedIn) {
      _username = prefs.getString('username') ?? '';
      _email = prefs.getString('email') ?? '';
    }
    notifyListeners();
  }
}