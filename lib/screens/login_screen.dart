import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../services/local_storage.dart';
import '../utils/app_utils.dart';
import 'home_screen.dart';

/// Login screen widget that handles user authentication.
///
/// Displays a login form with email and password fields.
/// Uses local SharedPreferences for credential validation.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    LocalStorage.initDefaultUserIfNeeded();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  /// Attempts to log in with the provided credentials.
  Future<void> _doLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final ok = await LocalStorage.login(
        _emailCtrl.text.trim(),
        _passCtrl.text,
      );

      setState(() => _loading = false);

      if (!mounted) return;

      if (ok) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        AppUtils.showErrorSnackBar(context, AppConstants.errorLoginFailed);
      }
    } catch (e) {
      setState(() => _loading = false);
      if (!mounted) return;
      AppUtils.showErrorSnackBar(context, AppConstants.errorLoginFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF6366F1).withOpacity(0.8),
              const Color(0xFFEC4899).withOpacity(0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with back button and title
              Padding(
                padding: const EdgeInsets.all(AppConstants.spacing16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: AppConstants.spacing8),
                    Text(
                      'Create Notes',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Main content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacing20,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: AppConstants.maxContentWidth,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: AppConstants.spacing40),
                        // Fingerprint icon/illustration
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(60),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.fingerprint_rounded,
                              color: Colors.white,
                              size: 60,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacing32),
                        // Title
                        Text(
                          'Sign In With Your Account',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: AppConstants.spacing12),
                        // Subtitle
                        Text(
                          'Use Your Email and Password For Quick and Easy To Access Your Account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacing40),
                        // Form
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Email field
                              TextFormField(
                                controller: _emailCtrl,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: AppConstants.labelEmail,
                                  fillColor: Colors.white,
                                  filled: true,
                                  prefixIcon: const Icon(Icons.email_outlined),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppConstants.borderRadius16,
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return AppConstants.errorEmailRequired;
                                  }
                                  if (!AppUtils.isValidEmail(v)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: AppConstants.spacing16),
                              // Password field
                              TextFormField(
                                controller: _passCtrl,
                                obscureText: _obscure,
                                decoration: InputDecoration(
                                  hintText: AppConstants.labelPassword,
                                  fillColor: Colors.white,
                                  filled: true,
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscure
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () =>
                                        setState(() => _obscure = !_obscure),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppConstants.borderRadius16,
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return AppConstants.errorPasswordRequired;
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacing24),
                        // Also Sign In button
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.spacing16,
                            vertical: AppConstants.spacing12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadius16,
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Also Sign In Using',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: AppConstants.spacing8),
                              Icon(
                                Icons.fingerprint_rounded,
                                color: Colors.white.withOpacity(0.7),
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacing32),
                        // Sign In button
                        SizedBox(
                          width: double.infinity,
                          height: AppConstants.buttonHeight,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _doLogin,
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
                            child: _loading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    AppConstants.labelSignIn,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
