import 'dart:convert';

import 'package:chefaa_frontend/services/api_services.dart';
import 'package:chefaa_frontend/services/storage_servicse.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum AuthErrorState { none, wrongPassword, invalidCredentials }

class AuthProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordObscured = true;
  bool get isPasswordObscured => _isPasswordObscured;

  AuthErrorState _errorState = AuthErrorState.none;
  AuthErrorState get errorState => _errorState;

  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, dynamic>? _userData;
  Map<String, dynamic>? get userData => _userData;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void togglePasswordVisability() {
    _isPasswordObscured = !_isPasswordObscured;
    notifyListeners();
  }

  Future<void> login() async {
    final identity = emailController.text.trim();
    final password = passwordController.text.trim();

    if (identity.isEmpty || password.isEmpty) {
      _errorMessage = "Please fill in all fields";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiServices.login(
        identity: identity,
        password: password,
      );

      if (response == null) {
        _isSuccess = false;
        _errorMessage = "Server error. Please try again later.";
        return;
      }
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        await StorageServicse.saveTokens(
          accessToken: data['accessToken'],
          refreshToken: data['refreshToken'],
        );

        _userData = data['user'];
        _isSuccess = true;
        _errorMessage = null;
      } else {
        _isSuccess = false;
        _errorMessage = data['message'] ?? "some error happened here";
      }
    } catch (e) {
      _isSuccess = false;
      _errorMessage = "Connection error. Please check your network.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


Future<void>logout()async{
  await ApiServices.logout();
  _isSuccess=false;
  _userData=null;
  notifyListeners();
}


  void resetSuccess() {
    _isSuccess = false;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
