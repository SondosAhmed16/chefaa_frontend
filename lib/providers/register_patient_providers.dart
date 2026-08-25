import 'dart:convert';

import 'package:chefaa_frontend/models/user_role.dart';
import 'package:chefaa_frontend/services/api_services.dart';
import 'package:chefaa_frontend/services/storage_servicse.dart';
import 'package:flutter/material.dart';

class RegisterPatientProviders extends ChangeNotifier {
  UserRole? _selectedRole;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;
  bool _isSuccess = false;
  bool _isLoading = false;
  String? _errorMessage = null;
  bool _agreeToTerms = false;

  bool get isPasswordObscured => _isPasswordObscure;
  bool get isConfirmObscured => _isConfirmPasswordObscure;
  bool get agreeToTerms => _agreeToTerms;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;
  UserRole? get selectedRole => _selectedRole;

  void selectRole(UserRole role) {
    _selectedRole = role;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordObscure = !_isPasswordObscure;
    notifyListeners();
  }

  void toggleConfirmVisibility() {
    _isConfirmPasswordObscure = !_isConfirmPasswordObscure;
    notifyListeners();
  }

  void setAgreeToTerms(bool? value) {
    _agreeToTerms = value ?? false;
    notifyListeners();
  }

  Future<void> registerPatient() async {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      _errorMessage = "All fields are required";
      notifyListeners();
      return;
    }

    if (password != confirmPassword) {
      _errorMessage = "Passwords do not match";
      notifyListeners();
      return;
    }

    if (!_agreeToTerms) {
      _errorMessage = "You must agree to the Terms & Privacy Policy";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final fullName = "$firstName $lastName";
      final userName =
          "${firstName.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}";

      final response = await ApiServices.registerPatient(
        name: fullName,
        userName: userName,
        email: email,
        password: password,
        phoneNumber: phone,
        role: _selectedRole!.value,
      );

      if (response == null) {
        _isSuccess = false;
        _errorMessage = "Server error. Please try again later.";
        return;
      }

      final Map<String, dynamic> data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        if (data['accessToken'] != null || data['refreshToken'] != null) {
          await StorageServicse.saveTokens(
            accessToken: data['accessToken'],
            refreshToken: data['refreshToken'],
          );
        }
        _isSuccess = true;
        _errorMessage = null;
      } else {
        _isSuccess = false;
        _errorMessage = data['message'] ?? "register failed";
      }
    } catch (e) {
      _isSuccess = false;
      _errorMessage = "connection error";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearRole() {
    _selectedRole = null;
    notifyListeners();
  }

  void resetState() {
    _isSuccess = false;
    _errorMessage = null;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
