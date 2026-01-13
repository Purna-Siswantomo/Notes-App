import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../models/note.dart';

/// Service for managing local storage of notes and authentication state.
///
/// This service handles:
/// - User authentication (login/logout)
/// - Persisting notes to SharedPreferences
/// - Loading notes from storage
class LocalStorage {
  // ---------- AUTH ----------

  /// Initializes default user credentials if they don't exist in storage.
  ///
  /// This is called once on app startup to ensure there's at least one
  /// valid user account for testing/demo purposes.
  static Future<void> initDefaultUserIfNeeded() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final e = sp.getString(AppConstants.storageKeyEmail);
      final p = sp.getString(AppConstants.storageKeyPassword);

      if (e == null || p == null) {
        await sp.setString(
          AppConstants.storageKeyEmail,
          AppConstants.defaultEmail,
        );
        await sp.setString(
          AppConstants.storageKeyPassword,
          AppConstants.defaultPassword,
        );
      }
    } catch (e) {
      print('Error initializing default user: $e');
    }
  }

  /// Attempts to log in with the provided [email] and [password].
  ///
  /// Returns `true` if login is successful, `false` otherwise.
  static Future<bool> login(String email, String password) async {
    try {
      final sp = await SharedPreferences.getInstance();
      final storedE = sp.getString(AppConstants.storageKeyEmail);
      final storedP = sp.getString(AppConstants.storageKeyPassword);

      final ok = (email == storedE && password == storedP);
      if (ok) await sp.setBool(AppConstants.storageKeyLoggedIn, true);
      return ok;
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  /// Logs out the current user by clearing the logged-in flag.
  static Future<void> logout() async {
    try {
      final sp = await SharedPreferences.getInstance();
      await sp.setBool(AppConstants.storageKeyLoggedIn, false);
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  /// Checks if a user is currently logged in.
  ///
  /// Returns `true` if user is logged in, `false` otherwise.
  static Future<bool> isLoggedIn() async {
    try {
      final sp = await SharedPreferences.getInstance();
      return sp.getBool(AppConstants.storageKeyLoggedIn) ?? false;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  // ---------- NOTES ----------

  /// Loads all saved notes from storage.
  ///
  /// Returns an empty list if no notes are found or in case of an error.
  /// Notes are automatically sorted by date (newest first).
  static Future<List<Note>> loadNotes() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final raw = sp.getString(AppConstants.storageKeyNotes);
      if (raw == null || raw.isEmpty) return [];

      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((e) => Note.fromJson(e as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    } catch (e) {
      print('Error loading notes: $e');
      return [];
    }
  }

  /// Saves a list of [notes] to storage.
  ///
  /// Throws an exception if the save operation fails.
  static Future<void> saveNotes(List<Note> notes) async {
    try {
      final sp = await SharedPreferences.getInstance();
      final encoded = jsonEncode(notes.map((n) => n.toJson()).toList());
      await sp.setString(AppConstants.storageKeyNotes, encoded);
    } catch (e) {
      print('Error saving notes: $e');
      rethrow;
    }
  }
}
