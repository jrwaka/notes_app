class Note {
  final String id;
  final String text;

  Note({
    required this.id,
    required this.text,
  });

  factory Note.fromMap(String id, Map<String, dynamic> data) {
    return Note(
      id: id,
      text: data['text'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
    };
  }
}
