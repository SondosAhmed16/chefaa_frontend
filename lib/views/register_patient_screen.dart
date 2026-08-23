import 'package:chefaa_frontend/providers/register_providers.dart';
import 'package:chefaa_frontend/views/login_screen.dart';
import 'package:chefaa_frontend/views/widgets/custom_text_field.dart';
import 'package:chefaa_frontend/views/widgets/success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPatientScreen extends StatelessWidget {
  const RegisterPatientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RegisterProviders>();
    final isError = provider.errorMessage != null;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (provider.isSuccess) {
        showDialog(
          context: context,
          builder: (_) => const SuccessDialog(
            title: "Success",
            message: "Your account has been successfully registered",
          ),
        ).then((_) {
          provider.resetState();
          Navigator.pop(context);
        });
      }
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
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

              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: provider.firstNameController,
                            hintText: "First Name",
                            preficIcon: Icons.person_outline,
                            isError: isError,
                          ),
                        ),
                        Expanded(
                          child: CustomTextField(
                            controller: provider.lastNameController,
                            hintText: "Last Name",
                            preficIcon: Icons.person_outline,
                            isError: isError,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),
                    CustomTextField(
                      controller: provider.phoneController,
                      hintText: "Enter your phone number",
                      preficIcon: Icons.phone_outlined,
                      isError: isError,
                    ),

                    const SizedBox(height: 14),
                    CustomTextField(
                      controller: provider.emailController,
                      hintText: "Enter your email",
                      preficIcon: Icons.email_outlined,
                      isError: isError,
                    ),

                    const SizedBox(height: 14),
                    CustomTextField(
                      controller: provider.passwordController,
                      hintText: "Enter your password",
                      preficIcon: Icons.lock_outline,
                      isError: isError,
                      suffixIcon: IconButton(
                        onPressed: () => provider.togglePasswordVisibility(),
                        icon: Icon(
                          provider.isPasswordObscured
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      controller: provider.confirmPasswordController,
                      hintText: "confirm your password",
                      preficIcon: Icons.lock_outline,
                      isError: isError,
                      suffixIcon: IconButton(
                        onPressed: () => provider.toggleConfirmVisibility(),
                        icon: Icon(
                          provider.isConfirmObscured
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey,
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
                    const SizedBox(height: 20),

                    // Create Account Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: provider.isLoading
                            ? null
                            : () => provider.register(),
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
                                "Create account",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),

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
