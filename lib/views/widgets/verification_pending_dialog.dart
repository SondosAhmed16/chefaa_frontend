import 'package:flutter/material.dart';

class VerificationPendingDialog extends StatelessWidget {
  final String? title;
  final String? message;
  final VoidCallback onOk;

  const VerificationPendingDialog({
    super.key,
    this.title = "Verification in progress",
    this.message =
        "Access to these features will be available once the verification is completed by administration.",
    required this.onOk,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50.withOpacity(isDark ? 0.2 : 1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.hourglass_top_rounded,
                size: 48,
                color: isDark ? Colors.amber.shade300 : Colors.amber.shade800,
              ),
            ),
            const SizedBox(height: 20),

            Text(
              title!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black87),
              ),
            ),
            const SizedBox(height: 10),

            Text(
              message!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: theme.hintColor,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: 120,
              height: 42,
              child: OutlinedButton(
                onPressed: onOk,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: theme.primaryColor, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  "OK",
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}