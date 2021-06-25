





final String tableNotes = 'notes';

class NoteFields {
  static final List<String> values = [
    //add all fields
    id, title, description, priority, date
  ];
  static final String id = '_id';
  static final String title = 'title';
  static final String description = 'description';
  static final String priority = 'priority';
  static final String date = 'date';
}

class Note {
  final int? id;
  final String? title;
  final String? description;
  final String priority;
  final DateTime date;

  const Note({
    this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.date,
  });

  Note copy({
    int? id,
    String? title,
    String? description,
    String? priority,
    DateTime? date,
  }) =>
      Note(
          id: id ?? this.id,
          title: title ?? this.title,
          description: description ?? this.description,
          priority: priority ?? this.priority,
          date: date ?? this.date);

  static Note fromJson(Map<String, Object?> json) => Note(
          id: json[NoteFields.id] as int?,
          title: json[NoteFields.title] as String,
          description:json[NoteFields.description] as String,
          priority: json[NoteFields.priority] as String,
          date : DateTime.parse(json[NoteFields.date] as String),

);
  Map<String, Object?> toJson() => {
        NoteFields.id: id,
        NoteFields.title: title,
        NoteFields.description: description,
        NoteFields.priority: priority,
        NoteFields.date: date.toIso8601String(),
      };
}
