# Daily Notes

A professional Flutter mobile application for creating, managing, and organizing daily notes with local authentication.

## Features

✨ **Core Features:**

- 📝 Create, read, update, and delete notes
- 🔐 Local authentication with username and password
- 📅 Date tracking for each note
- 💾 Persistent storage using SharedPreferences
- 🎨 Material Design 3 UI with gradient backgrounds
- 🔄 Automatic note sorting by date (newest first)
- 📱 Responsive design that works on all screen sizes

## Architecture

```
lib/
├── main.dart                 # Application entry point
├── constants/
│   └── app_constants.dart    # Centralized constants (strings, colors, sizes)
├── models/
│   └── note.dart             # Note data model with JSON serialization
├── screens/
│   ├── login_screen.dart     # Authentication screen
│   └── home_screen.dart      # Notes management screen
├── services/
│   └── local_storage.dart    # Storage service using SharedPreferences
├── utils/
│   └── app_utils.dart        # Utility functions (formatting, validation)
└── widgets/
    └── note_card.dart        # Reusable note card widget
```

## Getting Started

### Prerequisites

- Flutter SDK (^3.10.3)
- Dart SDK (included with Flutter)

### Installation

1. Clone the repository:

```bash
git clone <repository-url>
cd uas_mobile_catatan
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the app:

```bash
flutter run
```

### Default Credentials

For testing purposes, the app comes with a default account:

- **Username:** admin
- **Password:** admin123

## Project Structure

### Models (`lib/models/`)

- **Note.dart** - Represents a note with serialization/deserialization methods for JSON storage

### Services (`lib/services/`)

- **LocalStorage.dart** - Handles all data persistence and authentication using SharedPreferences

### Utilities (`lib/utils/`)

- **AppUtils.dart** - Contains helper functions:
  - Date formatting (`formatDate()`, `formatDateISO()`)
  - Input validation (`isNotEmpty()`, `isValidPassword()`)
  - UI feedback (`showSnackBar()`, `showErrorSnackBar()`)

### Constants (`lib/constants/`)

- **AppConstants.dart** - Centralized constants for:
  - UI strings (labels, error messages, hints)
  - Spacing and sizing values
  - Color definitions
  - Month names

### Screens (`lib/screens/`)

- **LoginScreen.dart** - Handles user authentication with form validation
- **HomeScreen.dart** - Main screen for note management and CRUD operations

### Widgets (`lib/widgets/`)

- **NoteCard.dart** - Reusable card widget for displaying individual notes

## Usage

### Creating a Note

1. Tap the floating action button or the "Tambah Catatan" button
2. Fill in the title and content
3. Select a date (optional, defaults to today)
4. Tap "Simpan" to save

### Editing a Note

1. Tap the "Edit" button on any note card
2. Modify the title, content, or date
3. Tap "Simpan" to update

### Deleting a Note

1. Tap the "Hapus" (Delete) button on any note card
2. Confirm the deletion in the dialog

### Logging Out

1. Tap the logout icon (⤾) in the top-right corner of the home screen
2. You'll be redirected to the login screen

## Technologies Used

- **Flutter** - Cross-platform mobile framework
- **Dart** - Programming language
- **SharedPreferences** - Local data persistence
- **Material Design 3** - Design system

## Code Quality Features

✅ **Professional Development Practices:**

- Comprehensive dartdoc comments for all classes and methods
- Centralized constants for maintainability
- Utility functions for common operations
- Error handling with try-catch blocks
- Form validation with meaningful error messages
- Proper resource management (TextEditingController disposal)
- Type-safe code with strong typing
- Responsive UI that adapts to screen size

## Future Enhancements

- 🔒 Advanced authentication (fingerprint, face recognition)
- ☁️ Cloud sync capabilities
- 🏷️ Note categories and tags
- 🔍 Search and filtering functionality
- 📤 Export notes to PDF or other formats
- 🌙 Dark mode support
- 🌐 Multi-language support

## Known Limitations

- Local storage only (no cloud sync)
- Single user per device
- No backup functionality currently implemented

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is created as an educational assignment.

## Support

For issues or questions, please create an issue in the repository.

---

**Version:** 1.0.0+1  
**Last Updated:** 2026

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
