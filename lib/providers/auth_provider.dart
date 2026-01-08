import 'package:flutter/material.dart';

import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  // Mock login - in real app, this would call an API
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Mock successful login
    if (email.isNotEmpty && password.isNotEmpty) {
      _currentUser = User(
        id: '1',
        email: email,
        name: email.split('@')[0],
      );
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Mock signup - in real app, this would call an API
  Future<bool> signup(String email, String password, String name) async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Mock successful signup
    if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
      _currentUser = User(
        id: '1',
        email: email,
        name: name,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
