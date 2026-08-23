import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData preficIcon;
  final bool isObscure;
  final Widget? suffixIcon;
  final bool isError;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isError = false,
    this.isObscure = false,
    required this.preficIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = isError ? Colors.red.shade300 : Colors.grey.shade300;

    return Container(
      decoration: BoxDecoration(
        color: theme.inputDecorationTheme.fillColor ?? Colors.grey.shade50,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: borderColor, width: 1.2),
      ),

      child: TextField(
        controller: controller,
        obscureText: isObscure,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          prefixIcon: Icon(
            preficIcon,
            color: isError ? Colors.red.shade300 : Colors.grey.shade400,
            size: 20,
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 16,
          ),
        ),
      ),
    );
  }
}
