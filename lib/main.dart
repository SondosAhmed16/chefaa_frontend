import 'package:chefaa_frontend/providers/auth_provider.dart';
import 'package:chefaa_frontend/providers/register_providers.dart';
import 'package:chefaa_frontend/providers/settings_providers.dart';
import 'package:chefaa_frontend/views/role_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProviders()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
                ChangeNotifierProvider(create: (_) => RegisterProviders()),

      ],
      child: const chefaaApp(),
    ),
  );
}

class chefaaApp extends StatelessWidget {
  const chefaaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProviders>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chefaa',
      locale: settings.locale,
      themeMode: settings.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF0052CC),
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Color(0xFFF8F9FA),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF4C8DFF),
        scaffoldBackgroundColor: const Color(0xFF121212),
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Color(0xFF1E1E1E),
        ),
      ),
      home: const RoleSelectionScreen(),
    );
  }
}
