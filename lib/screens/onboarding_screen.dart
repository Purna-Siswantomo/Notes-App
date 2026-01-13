import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'login_screen.dart';

/// Onboarding screen that introduces the app to new users.
///
/// Shows the app branding and a "Get Started" button to proceed to login.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromRGBO(99, 102, 241, 0.8),
              const Color.fromRGBO(236, 72, 153, 0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top decorative curve
              Expanded(
                flex: 2,
                child: Stack(
                  children: [
                    // Pink decorative circle
                    Positioned(
                      top: -30,
                      right: -30,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(255, 192, 203, 0.3),
                        ),
                      ),
                    ),
                    // Center content
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // App logo illustration
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 0.15),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Color.fromRGBO(255, 255, 255, 0.3),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.note_add_rounded,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Notes',
                                    style: TextStyle(
                                      color: Color.fromRGBO(255, 255, 255, 0.9),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          // App title
                          Text(
                            'NoteApp',
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Bottom content and button
              Expanded(
                flex: 1,
                child: Stack(
                  children: [
                    // Pink decorative circle
                    Positioned(
                      bottom: -40,
                      left: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.pink.withOpacity(0.2),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacing20,
                        vertical: AppConstants.spacing32,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Description text
                          Column(
                            children: [
                              Text(
                                'Welcome to NoteApp',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Organize your thoughts and ideas in one place.\nCreate, organize, and share your notes securely.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 0.85),
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                          // Get Started button
                          SizedBox(
                            width: double.infinity,
                            height: AppConstants.buttonHeight,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppConstants.colorBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppConstants.borderRadius16,
                                  ),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                AppConstants.labelGetStarted,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: AppConstants.colorBlue,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
