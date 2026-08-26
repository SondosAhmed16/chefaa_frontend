import 'dart:convert';
import 'dart:io';
import 'package:chefaa_frontend/services/api_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:chefaa_frontend/models/user_role.dart';
import 'package:flutter/material.dart';

class RegisterPharmacyProvider extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController licenseNumberController = TextEditingController();

  UserRole? _selectedRole;
  File? _pickedFile;
  String? _fileName;
  int? _fileSize;
  bool _isLoading = false;
  bool _isPasswordObscured = true;
  bool _isConfirmObscured = true;
  bool _agreeToTerms = false;
  String? _errorMessage;
  bool _isPendingVerification = false;

  UserRole? get selectedRole => _selectedRole;
  File? get pickedFile => _pickedFile;
  String? get fileName => _fileName;
  int? get fileSize => _fileSize;
  bool get isPasswordObscured => _isPasswordObscured;
  bool get isConfirmObscured => _isConfirmObscured;
  bool get agreeToTerms => _agreeToTerms;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isPendingVerification => _isPendingVerification;

  void selectRole(UserRole role) {
    _selectedRole = role;
    notifyListeners();
  }

  void clearRole() {
    _selectedRole = null;
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

  Future<void> registerPharmacy() async {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final commercialRegisterNumber = licenseNumberController.text.trim();

    if (name.isEmpty || phone.isEmpty || email.isEmpty || password.isEmpty) {
      _errorMessage = "Used email or phone / All fields required";
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
      final username =
          "dr_${name.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}";

      final streamedResponse = await ApiServices.registerPharmacy(
        name: name,
        username: username,
        email: email,
        password: password,
        phoneNumber: phone,
        commercialRegisterNumber: commercialRegisterNumber,
        filePath: _pickedFile!.path,
      );

      final response = await http.Response.fromStream(streamedResponse!);
      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        _isPendingVerification = true;
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
        return;
      } else {
        _errorMessage = data['message'] ?? "Registration failed";
        _isLoading = false;
        notifyListeners();
        return;
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
  }

  @override
  void dispose() {
    nameController.dispose();
    licenseNumberController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
