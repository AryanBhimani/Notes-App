class Note {
  String id;
  String title;
  String content;

  Note({
    required this.id,
    required this.title,
    required this.content, DateTime? dateTime,
  });

  // Convert a Note object to a Firestore document.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
    };
  }

  // Create a Note object from a Firestore document.
  factory Note.fromMap(String id, Map<String, dynamic> map) {
    return Note(
      id: id,
      title: map['title'],
      content: map['content'],
    );
  }

  DateTime? get dateTime => null;
}
