import 'dart:convert';
import 'dart:io';

import 'package:chefaa_frontend/models/doctor_models.dart';
import 'package:chefaa_frontend/services/api_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterDoctorProvider extends ChangeNotifier {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  DoctorModel? _registeredDoctor;

  String? _selectedSpecialization;
  File? _pickedFile;
  String? _fileName;
  int? _fileSize;

  bool _isPasswordObscured = true;
  bool _isConfirmObscured = true;
  bool _agreeToTerms = false;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isPendingVerification = false;

  final List<String> specializations = [
    'Internal Medicine',
    'Pediatrics',
    'Dermatology',
    'Cardiology',
    'Orthopedics',
    'Neurology',
  ];

  String? get selectedSpecialization => _selectedSpecialization;
  File? get pickedFile => _pickedFile;
  String? get fileName => _fileName;
  int? get fileSize => _fileSize;
  bool get isPasswordObscured => _isPasswordObscured;
  bool get isConfirmObscured => _isConfirmObscured;
  bool get agreeToTerms => _agreeToTerms;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isPendingVerification => _isPendingVerification;
  DoctorModel? get registeredDoctor => _registeredDoctor;

  void setSpecialization(String? val) {
    _selectedSpecialization = val;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordObscured = !_isPasswordObscured;
    notifyListeners();
  }

  void toggleConfirmVisibility() {
    _isConfirmObscured = !_isConfirmObscured;
    notifyListeners();
  }

  void setAgreeToTerms(bool? value) {
    _agreeToTerms = value ?? false;
    notifyListeners();
  }

  Future<void> filePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );

    if (result != null && result.files.single.path != null) {
      _pickedFile = File(result.files.single.path!);
      _fileName = result.files.single.name;
      _fileSize = result.files.single.size;

      notifyListeners();
    }
  }

  Future<void> registerDoctor() async {
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
      _errorMessage = "Used email or phone / All fields required";
      notifyListeners();
      return;
    }

    if (_selectedSpecialization == null) {
      _errorMessage = "please select your specialization";
      notifyListeners();
      return;
    }

    if (_pickedFile == null) {
      _errorMessage = "please upload your membership card";
      notifyListeners();
      return;
    }

    if (confirmPassword != password) {
      _errorMessage = "password do not match";
      notifyListeners();
      return;
    }

    if (!_agreeToTerms) {
      _errorMessage = "you must agree to terms & privacy policy";
      notifyListeners();
      return;
    }

    try {
      final fullName = "$firstName $lastName";
      final username =
          "dr_${firstName.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}";

      final streamedResponse = await ApiServices.registerDoctor(
        name: fullName,
        username: username,
        email: email,
        password: password,
        phoneNumber: phone,
        specialization: _selectedSpecialization!,
        filePath: _pickedFile!.path,
      );

      final response = await http.Response.fromStream(streamedResponse!);
      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (data['doctor'] != null) {
          _registeredDoctor = DoctorModel.fromJson(data['doctor']);
        }
        _isPendingVerification = true;
        _errorMessage = null;
      } else {
        _errorMessage = data['message'] ?? "Used email or phone";
      }
    } catch (e) {
      _errorMessage = "Connection error. Check network.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetState() {
    _isPendingVerification = false;
    _errorMessage = null;
    _registeredDoctor = null;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
