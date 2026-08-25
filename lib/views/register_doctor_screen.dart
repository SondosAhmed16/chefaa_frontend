import 'package:chefaa_frontend/providers/register_doctor_provider.dart';
import 'package:chefaa_frontend/views/login_screen.dart';
import 'package:chefaa_frontend/views/widgets/custom_text_field.dart';
import 'package:chefaa_frontend/views/widgets/upload_modal_bottom_sheet.dart';
import 'package:chefaa_frontend/views/widgets/verification_pending_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterDoctorScreen extends StatelessWidget {
  const RegisterDoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RegisterDoctorProvider>();
    final isError = provider.errorMessage != null;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (provider.isPendingVerification) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => VerificationPendingDialog(
            onOk: () {
              provider.resetState();
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 30),
                decoration: const BoxDecoration(
                  color: Color(0xFF0066CC),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Chefaa',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: provider.firstNameController,
                            hintText: "enter you first name",
                            preficIcon: Icons.person_outline,
                            isError: isError,
                          ),
                        ),

                        SizedBox(width: 12),
                        Expanded(
                          child: CustomTextField(
                            controller: provider.lastNameController,
                            hintText: "enter you last name",
                            preficIcon: Icons.person_outline,
                            isError: isError,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 12),
                    CustomTextField(
                      controller: provider.phoneController,
                      hintText: "enter you phone number",
                      preficIcon: Icons.phone_outlined,
                      isError: isError,
                    ),

                    SizedBox(height: 12),
                    CustomTextField(
                      controller: provider.emailController,
                      hintText: "enter you  email",
                      preficIcon: Icons.email_outlined,
                      isError: isError,
                    ),

                    SizedBox(height: 12),
                    CustomTextField(
                      controller: provider.passwordController,
                      hintText: "enter you password",
                      preficIcon: Icons.lock_outline,
                      isError: isError,
                      isObscure: provider.isPasswordObscured,
                      suffixIcon: IconButton(
                        onPressed: () => provider.togglePasswordVisibility(),
                        icon: Icon(
                          provider.isPasswordObscured
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    CustomTextField(
                      controller: provider.confirmPasswordController,
                      hintText: "confirm your password",
                      preficIcon: Icons.lock_outline,
                      isError: isError,
                      isObscure: provider.isConfirmObscured,
                      suffixIcon: IconButton(
                        onPressed: () => provider.toggleConfirmVisibility(),
                        icon: Icon(
                          provider.isConfirmObscured
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    ),

                    SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: isError ? Colors.red : Colors.grey.shade300,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: const Row(
                            children: [
                              Icon(
                                Icons.medical_information_outlined,
                                color: Colors.grey,
                                size: 20,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "select ypur specialization",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          value: provider.selectedSpecialization,
                          onChanged: (val) => provider.setSpecialization(val),
                          items: provider.specializations
                              .map(
                                (ele) => DropdownMenuItem(
                                  value: ele,
                                  child: Text(ele),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),

                    SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25),
                            ),
                          ),
                          builder: (_) => UploadModalBottomSheet(
                            onBrowse: () async {
                              Navigator.pop(context);
                              await provider.filePicker();
                            },
                          ),
                        );
                      },
                      child: provider.fileName == null
                          ? Container(
                              height: 48,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: isError
                                      ? Colors.red
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Upload your Membership Card",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Icon(
                                    Icons.upload_file_outlined,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.red.shade300),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      "PDF",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          provider.fileName!,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          "${(provider.fileSize! / 1024).toStringAsFixed(1)} KB of 50 MB",
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ),
                                ],
                              ),
                            ),
                    ),
                    if (isError)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "*${provider.errorMessage}",
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(
                          value: provider.agreeToTerms,
                          activeColor: const Color(0xFF0066CC),
                          onChanged: (v) => provider.setAgreeToTerms(v),
                        ),
                        Expanded(
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                              children: [
                                TextSpan(text: "I agree to the Docify "),
                                TextSpan(
                                  text: "Terms of Service ",
                                  style: TextStyle(
                                    color: Color(0xFF0066CC),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(text: "and "),
                                TextSpan(
                                  text: "Privacy Policy",
                                  style: TextStyle(
                                    color: Color(0xFF0066CC),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: provider.isLoading
                            ? null
                            : () => provider.registerDoctor(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isError
                              ? Colors.grey
                              : const Color(0xFF0066CC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 0,
                        ),
                        child: provider.isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                "Submit for Verification",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Do you already have an account? ",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Color(0xFF0066CC),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
