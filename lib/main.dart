import 'package:flutter/material.dart';
import 'constants/app_constants.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'services/local_storage.dart';

/// Entry point for the Create Notes application.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isLoggedIn = await LocalStorage.isLoggedIn();
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

/// Root widget of the application.
///
/// Sets up the Material theme, navigation, and initial route based on login status.
class MyApp extends StatelessWidget {
  /// Whether the user is currently logged in
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: AppConstants.colorPrimary,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius14),
            borderSide: BorderSide.none,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius16),
          ),
        ),
      ),
      home: isLoggedIn ? const HomeScreen() : const OnboardingScreen(),
    );
  }
}
