import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Utility functions for the Daily Notes application.
abstract class AppUtils {
  /// Formats a [DateTime] object into a readable string format (DD MMM YYYY).
  ///
  /// Example: 15 Jan 2024
  static String formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = AppConstants.monthNamesEnglish[date.month - 1];
    final year = date.year;
    return '$day $month $year';
  }

  /// Formats a [DateTime] object into YYYY-MM-DD format (suitable for display in date pickers).
  static String formatDateISO(DateTime date) {
    final year = date.year;
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  /// Shows a snack bar message at the bottom of the screen.
  static void showSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), duration: duration));
  }

  /// Shows an error snack bar (typically in red).
  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Truncates a string to a specified length with ellipsis if necessary.
  static String truncateString(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Validates if an email format is correct (basic validation).
  static bool isValidEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }

  /// Validates if a password meets basic requirements (minimum 6 characters).
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  /// Validates if a string is not empty when trimmed.
  static bool isNotEmpty(String? text) {
    return text != null && text.trim().isNotEmpty;
  }
}
