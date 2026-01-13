import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/note.dart';
import '../utils/app_utils.dart';

/// Widget that displays a single note in a card format.
///
/// Shows the note's title, content preview, and date.
/// Provides edit and delete action buttons with professional styling.
class NoteCard extends StatelessWidget {
  /// The note to display
  final Note note;

  /// Callback when the edit button is pressed
  final VoidCallback onEdit;

  /// Callback when the delete button is pressed
  final VoidCallback onDelete;

  const NoteCard({
    super.key,
    required this.note,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius16),
      ),
      child: Stack(
        children: [
          // Background gradient accent
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(0.05),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(AppConstants.borderRadius16),
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacing16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Date Row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note.title,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.3,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppConstants.spacing6),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 14,
                                color: Color.fromRGBO(
                                  cs.primary.r.toInt(),
                                  cs.primary.g.toInt(),
                                  cs.primary.b.toInt(),
                                  0.7,
                                ),
                              ),
                              const SizedBox(width: AppConstants.spacing4),
                              Text(
                                AppUtils.formatDate(note.date),
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: cs.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacing12),

                    // Visual indicator
                    Container(
                      padding: const EdgeInsets.all(AppConstants.spacing6),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(
                          cs.primary.r.toInt(),
                          cs.primary.g.toInt(),
                          cs.primary.b.toInt(),
                          0.1,
                        ),
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadius12,
                        ),
                      ),
                      child: Icon(
                        Icons.description_rounded,
                        size: 20,
                        color: cs.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacing12),

                // Content Preview
                Text(
                  note.content,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppConstants.spacing14),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Word count
                    Text(
                      '${note.content.split(' ').length} kata',
                      style: Theme.of(
                        context,
                      ).textTheme.labelSmall?.copyWith(color: Colors.grey[500]),
                    ),

                    // Buttons
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(33, 150, 243, 0.1),
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadius12,
                            ),
                          ),
                          child: IconButton(
                            onPressed: onEdit,
                            icon: const Icon(Icons.edit_rounded, size: 18),
                            color: Colors.blue,
                            tooltip: 'Edit',
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                        const SizedBox(width: AppConstants.spacing8),
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(244, 67, 54, 0.1),
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadius12,
                            ),
                          ),
                          child: IconButton(
                            onPressed: onDelete,
                            icon: const Icon(Icons.delete_rounded, size: 18),
                            color: Colors.red,
                            tooltip: 'Hapus',
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
