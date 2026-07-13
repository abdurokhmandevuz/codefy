import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'theme/app_theme.dart';
import 'screens/onboarding_screen.dart';
void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const CodefyApp(),
    ),
  );
}

class CodefyApp extends StatelessWidget {
  const CodefyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Codefy Mobile',
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: AppTheme.lightTheme,
      home: const OnboardingScreen(),
    );
  }
}
