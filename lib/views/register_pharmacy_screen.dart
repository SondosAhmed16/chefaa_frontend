import 'package:chefaa_frontend/providers/register_pharmacy_provider.dart';
import 'package:chefaa_frontend/providers/settings_providers.dart';
import 'package:chefaa_frontend/views/login_screen.dart';
import 'package:chefaa_frontend/views/widgets/custom_text_field.dart';
import 'package:chefaa_frontend/views/widgets/upload_modal_bottom_sheet.dart';
import 'package:chefaa_frontend/views/widgets/verification_pending_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPharmacyScreen extends StatelessWidget {
  const RegisterPharmacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RegisterPharmacyProvider>();
    final settings = context.watch<SettingsProviders>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
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
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
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
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 30),
                decoration: BoxDecoration(
                  color: Color(0xFF0066CC),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Center(
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
                    CustomTextField(
                      controller: provider.nameController,
                      hintText: "Full Pharmacy legal name",
                      preficIcon: Icons.local_pharmacy_outlined,
                      isError: isError,
                    ),

                    SizedBox(height: 12),
                    CustomTextField(
                      controller: provider.emailController,
                      hintText: "enter pharmacy work email",
                      preficIcon: Icons.email_outlined,
                      isError: isError,
                    ),

                    SizedBox(height: 12),
                    CustomTextField(
                      controller: provider.phoneController,
                      hintText: "enter pharmacy phone number",
                      preficIcon: Icons.phone_outlined,
                      isError: isError,
                    ),

                    SizedBox(height: 12),
                    CustomTextField(
                      controller: provider.passwordController,
                      hintText: "enter pharmacy password",
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
                      hintText: "re-enter pharmacy password",
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
                    CustomTextField(
                      controller: provider.licenseNumberController,
                      hintText: "enter pharmacy Commerical License number",
                      preficIcon: Icons.badge_outlined,
                      isError: isError,
                    ),

                    SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
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
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? theme.inputDecorationTheme.fillColor
                                    : const Color(0xDDD8F9FA),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: isError
                                      ? Colors.red
                                      : (isDark
                                            ? Colors.grey.shade800
                                            : Colors.grey.shade300),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "upload your Licenese",
                                    style: TextStyle(
                                      color: theme.hintColor,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Icon(
                                    Icons.upload_file_outlined,
                                    color: theme.hintColor,
                                    size: 20,
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF1E1E1E)
                                    : const Color(0xFFF8F9FA),
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
                                          style: TextStyle(
                                            color: theme
                                                .textTheme
                                                .bodyMedium
                                                ?.color,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          "${(provider.fileSize! / 1024).toStringAsFixed(1)} KB of 50 MB",
                                          style: TextStyle(
                                            color: theme.hintColor,
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
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          "*${provider.errorMessage}",
                          style: TextStyle(color: Colors.red, fontSize: 11),
                        ),
                      ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(
                          value: provider.agreeToTerms,
                          activeColor: theme.primaryColor,
                          onChanged: (v) => provider.setAgreeToTerms(v),
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: theme.hintColor,
                                fontSize: 11,
                              ),
                              children: [
                                TextSpan(text: "I agree to the Docify "),
                                TextSpan(
                                  text: "Terms of Service ",
                                  style: TextStyle(
                                    color: theme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(text: "and "),
                                TextSpan(
                                  text: "Privacy Policy",
                                  style: TextStyle(
                                    color: theme.primaryColor,
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
                            : () => provider.registerPharmacy(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isError
                              ? Colors.grey
                              : theme.primaryColor,
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
                            color: theme.hintColor,
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
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: theme.primaryColor,
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
