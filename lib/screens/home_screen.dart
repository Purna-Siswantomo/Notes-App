import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/note.dart';
import '../services/local_storage.dart';
import '../utils/app_utils.dart';
import 'create_note_screen.dart';
import 'login_screen.dart';

/// Home screen widget displaying the list of notes.
///
/// Provides functionality to:
/// - View all saved notes
/// - Search notes
/// - Filter by category
/// - Add new notes
/// - Edit existing notes
/// - Delete notes
/// - Logout
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> _allNotes = [];
  List<Note> _filteredNotes = [];
  bool _loading = true;
  String? _selectedCategory;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
    _searchCtrl.addListener(_filterNotes);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  /// Loads notes from storage.
  Future<void> _load() async {
    try {
      final notes = await LocalStorage.loadNotes();
      if (!mounted) return;
      setState(() {
        _allNotes = notes;
        _filteredNotes = notes;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      AppUtils.showErrorSnackBar(context, AppConstants.errorLoadingFailure);
    }
  }

  /// Filters notes based on search query and selected category.
  void _filterNotes() {
    String query = _searchCtrl.text.toLowerCase();

    setState(() {
      _filteredNotes = _allNotes.where((note) {
        final matchesSearch =
            note.title.toLowerCase().contains(query) ||
            note.content.toLowerCase().contains(query);

        final matchesCategory =
            _selectedCategory == null || note.category == _selectedCategory;

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  /// Persists notes to storage.
  Future<void> _persist() async {
    try {
      await LocalStorage.saveNotes(_allNotes);
    } catch (e) {
      if (!mounted) return;
      AppUtils.showErrorSnackBar(context, AppConstants.errorStorageFailure);
    }
  }

  /// Logs out the current user and navigates to login screen.
  Future<void> _logout() async {
    try {
      await LocalStorage.logout();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    } catch (e) {
      if (!mounted) return;
      AppUtils.showErrorSnackBar(context, 'Logout failed');
    }
  }

  /// Navigates to create/edit note screen.
  Future<void> _openNoteEditor({Note? existing}) async {
    final result = await Navigator.push<Note>(
      context,
      MaterialPageRoute(
        builder: (_) => CreateNoteScreen(existingNote: existing),
      ),
    );

    if (result != null) {
      if (existing != null) {
        // Edit existing note
        final idx = _allNotes.indexWhere((n) => n.id == existing.id);
        if (idx != -1) {
          _allNotes[idx] = result;
        }
      } else {
        // Add new note
        _allNotes.insert(0, result);
      }
      await _persist();
      _filterNotes();
    }
  }

  /// Deletes a note after confirmation.
  Future<void> _deleteNote(Note note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text(AppConstants.labelDeleteConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(AppConstants.labelCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(AppConstants.labelDelete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _allNotes.removeWhere((n) => n.id == note.id);
        _filterNotes();
      });
      await _persist();
      if (mounted) {
        AppUtils.showSnackBar(context, 'Note deleted');
      }
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
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    // Header with logout
                    Padding(
                      padding: const EdgeInsets.all(AppConstants.spacing16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 48),
                          Text(
                            'My Notes',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                          ),
                          PopupMenuButton(
                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ),
                            itemBuilder: (ctx) => [
                              PopupMenuItem(
                                onTap: _logout,
                                child: const Row(
                                  children: [
                                    Icon(Icons.logout, size: 20),
                                    SizedBox(width: 8),
                                    Text(AppConstants.labelLogout),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Search bar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacing16,
                      ),
                      child: TextField(
                        controller: _searchCtrl,
                        decoration: InputDecoration(
                          hintText: AppConstants.labelSearch,
                          hintStyle: TextStyle(color: Colors.grey.shade600),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.shade600,
                          ),
                          suffixIcon: _searchCtrl.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchCtrl.clear();
                                    _filterNotes();
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadius16,
                            ),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacing12),
                    // Category filter chips
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacing16,
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            FilterChip(
                              label: const Text('All'),
                              selected: _selectedCategory == null,
                              backgroundColor: Colors.white.withOpacity(0.7),
                              selectedColor: Colors.white,
                              onSelected: (_) {
                                setState(() => _selectedCategory = null);
                                _filterNotes();
                              },
                            ),
                            const SizedBox(width: AppConstants.spacing8),
                            ...AppConstants.noteCategories.map((category) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  right: AppConstants.spacing8,
                                ),
                                child: FilterChip(
                                  label: Text(category),
                                  backgroundColor: Colors.white.withOpacity(
                                    0.7,
                                  ),
                                  selectedColor: Colors.white,
                                  selected: _selectedCategory == category,
                                  onSelected: (_) {
                                    setState(
                                      () => _selectedCategory = category,
                                    );
                                    _filterNotes();
                                  },
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacing16),
                    // Notes list or empty state
                    if (_filteredNotes.isEmpty)
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.note_outlined,
                                size: 64,
                                color: Colors.white.withOpacity(0.5),
                              ),
                              const SizedBox(height: AppConstants.spacing16),
                              Text(
                                AppConstants.labelNoNotes,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(color: Colors.white),
                              ),
                              const SizedBox(height: AppConstants.spacing8),
                              Text(
                                AppConstants.labelNoNotesDescription,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.spacing16,
                            vertical: AppConstants.spacing12,
                          ),
                          itemCount: _filteredNotes.length,
                          itemBuilder: (ctx, idx) {
                            final note = _filteredNotes[idx];
                            return _buildNoteCard(note);
                          },
                        ),
                      ),
                  ],
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openNoteEditor(),
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Builds a note card widget.
  Widget _buildNoteCard(Note note) {
    final color =
        AppConstants.noteColors[note.color % AppConstants.noteColors.length];
    final hasDrawing =
        note.drawings != null && (note.drawings as List).isNotEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.spacing12),
      child: InkWell(
        onTap: () => _openNoteEditor(existing: note),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius16),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: AppConstants.spacing4),
                        Text(
                          AppUtils.formatDate(note.date),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacing8),
                  if (hasDrawing)
                    Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: Colors.grey.shade600,
                    ),
                  const SizedBox(width: AppConstants.spacing8),
                  PopupMenuButton(
                    itemBuilder: (ctx) => [
                      PopupMenuItem(
                        onTap: () => _openNoteEditor(existing: note),
                        child: const Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () => _deleteNote(note),
                        child: const Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacing12),
              if (hasDrawing)
                Column(
                  children: [
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadius12,
                        ),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit, color: color, size: 32),
                            const SizedBox(height: 8),
                            Text(
                              'Drawing included',
                              style: TextStyle(
                                color: color,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacing12),
                  ],
                ),
              Text(
                note.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: AppConstants.spacing12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacing8,
                      vertical: AppConstants.spacing4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadius12,
                      ),
                    ),
                    child: Text(
                      note.category,
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (note.reminderTime != null) ...[
                    const SizedBox(width: AppConstants.spacing8),
                    Icon(Icons.alarm_on, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      AppUtils.formatDate(note.reminderTime!),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
