import 'package:flutter/material.dart';

class UploadModalBottomSheet extends StatelessWidget {
  final VoidCallback onBrowse;

  const UploadModalBottomSheet({super.key, required this.onBrowse});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Upload your Membership Card",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: theme.iconTheme.color),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onBrowse,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                color: isDark
                    ? theme.primaryColor.withOpacity(0.15)
                    : Colors.blue.shade50.withOpacity(0.5),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: theme.primaryColor,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 40,
                    color: theme.primaryColor,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Choose a file",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "JPEG, PNG, PDF formats up to 50MB",
                    style: TextStyle(color: theme.hintColor, fontSize: 11),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton(
                    onPressed: onBrowse,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.grey.shade800 : Colors.white,
                      foregroundColor: isDark ? Colors.white : Colors.black,
                      elevation: 1,
                    ),
                    child: const Text(
                      "Browse files",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}