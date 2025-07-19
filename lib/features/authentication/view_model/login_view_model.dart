import 'package:flutter/material.dart';

import '../model/login_model.dart';

enum LoginState { initial, loading, success, error }

class LoginViewModel extends ChangeNotifier {
  LoginState _state = LoginState.initial;
  String? _errorMessage;

  LoginState get state => _state;

  String? get errorMessage => _errorMessage;

  Future<bool> login(LoginModel loginData) async {
    _state = LoginState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Dummy validation
      if (loginData.email == 'test@example.com' &&
          loginData.password == 'password123') {
        _state = LoginState.success;
        notifyListeners();
        return true;
      } else {
        _state = LoginState.error;
        _errorMessage = 'Invalid email or password';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _state = LoginState.error;
      _errorMessage = 'An error occurred. Please try again.';
      notifyListeners();
      return false;
    }
  }

  void reset() {
    _state = LoginState.initial;
    _errorMessage = null;
    notifyListeners();
  }
}
