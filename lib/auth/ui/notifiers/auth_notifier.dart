import 'package:flutter/material.dart';
import 'package:pets/auth/domain/adapters/user.dart';
import 'package:pets/auth/domain/use_case/auth_use_case.dart';
import 'package:pets/auth/application/dependencies/auth_dependency.dart';
class AuthNotifier extends ChangeNotifier {
  final AuthUseCase _authUseCase = AuthDependencies.getAuthUseCase();

  bool _isLoading = false;
  String? _errorMessage;
  User? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _user;
  bool get isAuthenticated => _user != null;

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    clearError();

    final result = await _authUseCase.login(email, password);
    
    _setLoading(false);

    if (result.isSuccess) {
      _user = result.user;
      return true;
    } else {
      _errorMessage = result.error ?? "Error desconocido";
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    clearError();

    final result = await _authUseCase.register(name, email, password);
    
    _setLoading(false);

    if (result.isSuccess) {
      _user = result.user;
      return true;
    } else {
      _errorMessage = result.error ?? "Error desconocido";
      return false;
    }
  }

  // Future<void> logout() async {
  //   await _authUseCase.logout();
  //   _user = null;
  //   _clearError();
  //   notifyListeners();
  // }

  Future<void> checkAuthStatus() async {
    final isAuth = await _authUseCase.isAuthenticated();
    if (!isAuth) {
      _user = null;
      notifyListeners();
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
  }
}