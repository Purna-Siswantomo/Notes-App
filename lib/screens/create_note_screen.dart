import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/note.dart';
import '../utils/app_utils.dart';
import '../widgets/drawing_canvas.dart';

/// Screen for creating or editing a note with advanced features.
///
/// Allows users to:
/// - Edit title and content
/// - Select category
/// - Choose note color
/// - Set reminder time
/// - Draw sketches
class CreateNoteScreen extends StatefulWidget {
  final Note? existingNote;

  const CreateNoteScreen({super.key, this.existingNote});

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen>
    with TickerProviderStateMixin {
  late TextEditingController _titleCtrl;
  late TextEditingController _contentCtrl;
  late String _selectedCategory;
  late int _selectedColor;
  DateTime? _reminderTime;
  late TabController _tabController;
  List<DrawingStroke> _drawings = [];
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    _titleCtrl = TextEditingController(text: widget.existingNote?.title ?? '');
    _contentCtrl = TextEditingController(
      text: widget.existingNote?.content ?? '',
    );
    _selectedCategory =
        widget.existingNote?.category ?? AppConstants.noteCategories.first;
    _selectedColor = widget.existingNote?.color ?? 0;
    _reminderTime = widget.existingNote?.reminderTime;

    // Load existing drawings if editing
    if (widget.existingNote?.drawings != null) {
      try {
        _drawings = (widget.existingNote!.drawings as List)
            .map(
              (stroke) =>
                  DrawingStroke.fromJson(stroke as Map<String, dynamic>),
            )
            .toList();
      } catch (e) {
        _drawings = [];
      }
    }
  }

  void _handleTabChange() {
    setState(() {
      _selectedTabIndex = _tabController.index;
    });
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    _tabController.dispose();
    super.dispose();
  }

  /// Saves the note and returns it.
  void _saveNote() {
    if (_titleCtrl.text.trim().isEmpty) {
      AppUtils.showErrorSnackBar(context, AppConstants.errorTitleRequired);
      return;
    }
    if (_contentCtrl.text.trim().isEmpty) {
      AppUtils.showErrorSnackBar(context, AppConstants.errorContentRequired);
      return;
    }

    final note = Note(
      id:
          widget.existingNote?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleCtrl.text.trim(),
      content: _contentCtrl.text.trim(),
      date: widget.existingNote?.date ?? DateTime.now(),
      category: _selectedCategory,
      color: _selectedColor,
      reminderTime: _reminderTime,
      drawings: _drawings.map((s) => s.toJson()).toList(),
    );

    Navigator.pop(context, note);
  }

  /// Opens date and time picker for reminder.
  Future<void> _pickReminderDateTime() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _reminderTime ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );

    if (pickedDate == null) return;

    if (!mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_reminderTime ?? now),
    );

    if (pickedTime == null) return;

    setState(() {
      _reminderTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromRGBO(99, 102, 241, 0.8),
              const Color.fromRGBO(236, 72, 153, 0.6),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(AppConstants.spacing16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    Text(
                      widget.existingNote == null
                          ? AppConstants.labelAddNote
                          : AppConstants.labelEditNote,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              // Tab bar for Text/Drawing
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacing16,
                  vertical: AppConstants.spacing12,
                ),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadius20,
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildCustomTabButton(
                        label: 'Text',
                        isSelected: _selectedTabIndex == 0,
                        onTap: () {
                          setState(() => _selectedTabIndex = 0);
                          _tabController.animateTo(0);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildCustomTabButton(
                        label: 'Draw',
                        isSelected: _selectedTabIndex == 1,
                        onTap: () {
                          setState(() => _selectedTabIndex = 1);
                          _tabController.animateTo(1);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.spacing12),
              // Tab content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Text tab
                    _buildTextEditingTab(),
                    // Drawing tab
                    _buildDrawingTab(),
                  ],
                ),
              ),
              // Save button
              Padding(
                padding: const EdgeInsets.all(AppConstants.spacing16),
                child: SizedBox(
                  width: double.infinity,
                  height: AppConstants.buttonHeight,
                  child: FilledButton(
                    onPressed: _saveNote,
                    child: const Text(
                      AppConstants.labelSave,
                      style: TextStyle(fontWeight: FontWeight.bold),
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

  /// Builds the text editing tab with title, content, category, color, and reminder.
  Widget _buildTextEditingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title field
          TextField(
            controller: _titleCtrl,
            decoration: InputDecoration(
              hintText: AppConstants.labelTitle,
              filled: true,
              fillColor: const Color.fromRGBO(255, 255, 255, 0.8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppConstants.borderRadius16,
                ),
                borderSide: BorderSide.none,
              ),
            ),
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppConstants.spacing20),
          // Content field
          TextField(
            controller: _contentCtrl,
            maxLines: 8,
            decoration: InputDecoration(
              hintText: AppConstants.labelContent,
              filled: true,
              fillColor: const Color.fromRGBO(255, 255, 255, 0.8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppConstants.borderRadius16,
                ),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: AppConstants.spacing24),
          // Category selection
          Text(
            AppConstants.labelCategories,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppConstants.spacing12),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: AppConstants.noteCategories.map((category) {
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: AppConstants.spacing8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() => _selectedCategory = category);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppConstants.spacing24),
          // Color selection
          Text(
            AppConstants.labelColors,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppConstants.spacing12),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: AppConstants.noteColors.length,
              itemBuilder: (ctx, idx) {
                final color = AppConstants.noteColors[idx];
                final isSelected = idx == _selectedColor;
                return Padding(
                  padding: const EdgeInsets.only(right: AppConstants.spacing12),
                  child: InkWell(
                    onTap: () => setState(() => _selectedColor = idx),
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Colors.black, width: 3)
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 24,
                            )
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppConstants.spacing24),
          // Reminder section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppConstants.labelReminder,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (_reminderTime != null)
                IconButton(
                  onPressed: () => setState(() => _reminderTime = null),
                  icon: const Icon(Icons.close),
                ),
            ],
          ),
          if (_reminderTime == null)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _pickReminderDateTime,
                icon: const Icon(Icons.add),
                label: const Text('Add Reminder'),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacing16,
                vertical: AppConstants.spacing12,
              ),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(
                  AppConstants.borderRadius16,
                ),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reminder scheduled',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${AppUtils.formatDate(_reminderTime!)} at ${_reminderTime!.hour.toString().padLeft(2, '0')}:${_reminderTime!.minute.toString().padLeft(2, '0')}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: _pickReminderDateTime,
                    icon: const Icon(Icons.edit),
                  ),
                ],
              ),
            ),
          const SizedBox(height: AppConstants.spacing32),
        ],
      ),
    );
  }

  /// Builds the drawing tab with canvas and drawing tools.
  Widget _buildDrawingTab() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing12),
      child: DrawingCanvas(
        initialStrokes: _drawings,
        onStrokesChanged: (strokes) {
          setState(() => _drawings = strokes);
        },
      ),
    );
  }

  /// Builds a custom tab button with modern styling.
  Widget _buildCustomTabButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.95)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
          border: isSelected
              ? Border.all(color: Colors.white.withOpacity(0.3), width: 1)
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected
                ? const Color(0xFF6366F1) // Original blue
                : Colors.white.withOpacity(0.9),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
