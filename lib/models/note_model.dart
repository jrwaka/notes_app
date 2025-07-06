class Note {
  final String id;
  final String text;
  final String userId;

  Note({
    required this.id,
    required this.text,
    required this.userId,
  });

  factory Note.fromMap(String id, Map<String, dynamic> data) {
    return Note(
      id: id,
      text: data['text'] ?? '',
      userId: data['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'userId': userId,
    };
  }
}
