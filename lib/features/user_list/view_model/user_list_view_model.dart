import 'package:flutter/material.dart';

import '../../../constants/api_constants.dart';
import '../../../services/api_service.dart';
import '../model/user_model.dart';

enum UsersState { initial, loading, loaded, error }

class UsersViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<User> _users = [];
  UsersState _state = UsersState.initial;
  String? _errorMessage;

  List<User> get users => _users;

  UsersState get state => _state;

  String? get errorMessage => _errorMessage;

  Future<void> loadUsers() async {
    _state = UsersState.loading;
    notifyListeners();

    try {
      _users = await _apiService.get<List<User>>(
        ApiConstants.usersEndpoint,
        (json) => (json as List).map((e) => User.fromJson(e)).toList(),
      );
      _state = UsersState.loaded;
    } catch (e) {
      _state = UsersState.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}
