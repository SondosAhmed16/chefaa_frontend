import 'package:chefaa_frontend/views/register_patient_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/settings_providers.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/success_dialog.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProviders>();
    final auth = context.watch<AuthProvider>();

    // عرض الحوار (Dialog) في حالة النجاح
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (auth.isSuccess) {
        showDialog(
          context: context,
          builder: (_) => const SuccessDialog(
            title: "Yeay! Welcome Back",
            message: "Once again you login successfully into Chefaa app",
          ),
        ).then((_) => context.read<AuthProvider>().resetSuccess());
      }
    });

    final isError = auth.errorMessage != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              settings.isDarkMood ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () => context.read<SettingsProviders>().toggleTheme(),
          ),
          TextButton(
            onPressed: () => context.read<SettingsProviders>().toggleLanguage(),
            child: Text(settings.locale.languageCode == 'en' ? 'عربي' : 'EN'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Logo
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Chefaa',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.medical_services_outlined,
                    color: Theme.of(context).primaryColor,
                    size: 36,
                  ),
                ],
              ),
              const SizedBox(height: 50),

              // Email / Phone Field
              CustomTextField(
                controller: auth.emailController,
                hintText: "Enter your email or phone",
                preficIcon: Icons.email_outlined,
                isError: isError,
              ),
              const SizedBox(height: 16),

              // Password Field
              CustomTextField(
                controller: auth.passwordController,
                hintText: "Enter your password",
                preficIcon: Icons.lock_outline,
                isObscure: auth.isPasswordObscured,
                isError: isError,
                suffixIcon: IconButton(
                  icon: Icon(
                    auth.isPasswordObscured
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey,
                    size: 20,
                  ),
                  onPressed: () =>
                      context.read<AuthProvider>().togglePasswordVisability(),
                ),
              ),

              // Dynamic Error Message & Forgot Password
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (isError)
                      Expanded(
                        child: Text(
                          "*${auth.errorMessage}",
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    else
                      const SizedBox.shrink(),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                      ),
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Color(0xFF0066CC),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Login Button with Loading Indicator
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: auth.isLoading
                      ? null
                      : () => context.read<AuthProvider>().login(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0052CC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                  child: auth.isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 30),

              // Social Logins
              _buildSocialButton(
                icon: Icons.g_mobiledata,
                label: "Sign in with Google",
                onTap: () {},
              ),
              const SizedBox(height: 12),
              _buildSocialButton(
                icon: Icons.apple,
                label: "Sign in with Apple",
                onTap: () {},
              ),
              const SizedBox(height: 24),

              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterPatientScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Color(0xFF0066CC),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
