/// Represents a note in the Daily Notes application.
///
/// Each note contains:
/// - [id]: Unique identifier (generated from microseconds since epoch)
/// - [title]: The title of the note
/// - [content]: The content/body of the note
/// - [date]: The date when the note was created or last edited
/// - [category]: The category of the note (e.g., 'Expenses', 'Meeting', 'Ideas')
/// - [color]: The color index for the note (0-4)
/// - [reminderTime]: Optional reminder time for the note
/// - [drawings]: Optional list of drawing strokes as JSON
class Note {
  /// Unique identifier for this note
  String id;

  /// Title of the note
  String title;

  /// Content/body of the note
  String content;

  /// Date associated with this note
  DateTime date;

  /// Category of the note
  String category;

  /// Color index for the note (0-4 representing different colors)
  int color;

  /// Optional reminder time for the note
  DateTime? reminderTime;

  /// Drawing strokes as JSON (serialized drawing data)
  List<dynamic>? drawings;

  /// Creates a new [Note] instance.
  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    this.category = 'General',
    this.color = 0,
    this.reminderTime,
    this.drawings,
  });

  /// Converts this [Note] to a JSON-serializable map.
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'date': date.toIso8601String(),
    'category': category,
    'color': color,
    'reminderTime': reminderTime?.toIso8601String(),
    'drawings': drawings,
  };

  /// Creates a [Note] from a JSON map.
  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'] as String,
    title: json['title'] as String,
    content: json['content'] as String,
    date: DateTime.parse(json['date'] as String),
    category: json['category'] as String? ?? 'General',
    color: json['color'] as int? ?? 0,
    reminderTime: json['reminderTime'] != null
        ? DateTime.parse(json['reminderTime'] as String)
        : null,
    drawings: json['drawings'] as List<dynamic>?,
  );
}
