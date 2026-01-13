import 'package:flutter/material.dart';

/// Application-wide constants for the Daily Notes app.
abstract class AppConstants {
  // ========== STRINGS ==========
  /// Application title
  static const String appTitle = 'Create Notes';

  /// Default credentials for local authentication
  static const String defaultEmail = 'user@example.com';
  static const String defaultPassword = 'password123';

  /// Storage keys
  static const String storageKeyEmail = 'email';
  static const String storageKeyPassword = 'password';
  static const String storageKeyLoggedIn = 'logged_in';
  static const String storageKeyNotes = 'notes_json';

  // ========== UI STRINGS ==========
  /// Dialog and button labels
  static const String labelAddNote = 'Create Notes';
  static const String labelEditNote = 'Edit Note';
  static const String labelCancel = 'Cancel';
  static const String labelSave = 'Save';
  static const String labelDelete = 'Delete';
  static const String labelDeleteConfirmation = 'Delete this note?';
  static const String labelTitle = 'Add Title';
  static const String labelContent = 'Add Note';
  static const String labelDate = 'Date';
  static const String labelNoNotes = 'No Notes Yet';
  static const String labelNoNotesDescription =
      'Create your first note by tapping the + button';
  static const String labelLogin = 'Login';
  static const String labelLogout = 'Logout';
  static const String labelEmail = 'Email';
  static const String labelPassword = 'Password';
  static const String labelSignIn = 'Sign In';
  static const String labelGetStarted = 'Get Started';
  static const String labelCategories = 'Categories';
  static const String labelColors = 'Colors';
  static const String labelReminder = 'Reminder';
  static const String labelSearch = 'Search by Notes, Categories Etc';

  // Category labels
  static const String categoryExpense = 'Expense';
  static const String categoryMeeting = 'Meeting';
  static const String categoryTodo = 'To Do';
  static const String categoryReminder = 'Reminder';
  static const String categoryIdea = 'Idea';

  static const List<String> noteCategories = [
    categoryExpense,
    categoryMeeting,
    categoryTodo,
    categoryReminder,
    categoryIdea,
  ];

  // ========== ERROR MESSAGES ==========
  static const String errorTitleRequired = 'Title is required';
  static const String errorContentRequired = 'Content is required';
  static const String errorEmailRequired = 'Email is required';
  static const String errorPasswordRequired = 'Password is required';
  static const String errorLoginFailed =
      'Login failed. Please check your email and password.';
  static const String errorStorageFailure =
      'Failed to save data. Please try again.';
  static const String errorLoadingFailure =
      'Failed to load data. Please try again.';

  // ========== SPACING & SIZING ==========
  static const double spacing4 = 4.0;
  static const double spacing6 = 6.0;
  static const double spacing8 = 8.0;
  static const double spacing10 = 10.0;
  static const double spacing12 = 12.0;
  static const double spacing14 = 14.0;
  static const double spacing16 = 16.0;
  static const double spacing18 = 18.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing40 = 40.0;

  static const double borderRadius12 = 12.0;
  static const double borderRadius14 = 14.0;
  static const double borderRadius16 = 16.0;
  static const double borderRadius20 = 20.0;

  static const double iconSizeMedium = 18.0;
  static const double iconSizeLarge = 44.0;

  static const double buttonHeight = 48.0;

  // ========== CONTENT CONSTRAINTS ==========
  static const double maxContentWidth = 520.0;

  // ========== COLORS ==========
  static const Color colorPrimary = Color(0xFF6366F1);
  static const Color colorBlue = Color(0xFF6366F1);
  static const Color colorPink = Color(0xFFEC4899);
  static const Color colorYellow = Color(0xFFF59E0B);
  static const Color colorGreen = Color(0xFF10B981);
  static const Color colorPurple = Color(0xFF8B5CF6);

  static const List<Color> noteColors = [
    colorYellow,
    colorPink,
    colorGreen,
    colorPurple,
    colorBlue,
  ];

  // ========== MONTH NAMES ==========
  static const List<String> monthNamesEnglish = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
}
