import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note_model.dart';
import 'package:firebase_auth/firebase_auth.dart';


class NotesProvider with ChangeNotifier {
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

List<Note> _notes = [];
bool _isLoading = false;

List<Note> get notes => _notes;
bool get isLoading => _isLoading;

void _setLoading(bool value) {
_isLoading = value;
notifyListeners();
}

Future<void> fetchNotes() async {
  _setLoading(true);
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("No user logged in");

    final snapshot = await _firestore
        .collection('notes')
        .where('userId', isEqualTo: user.uid)
        .get();

    _notes = snapshot.docs
        .map((doc) => Note.fromMap(doc.id, doc.data()))
        .toList();
  } catch (e) {
    debugPrint('Error fetching notes: $e');
  } finally {
    _setLoading(false);
  }
}


Future<void> addNote(String text) async {
try {
final user = FirebaseAuth.instance.currentUser;
if (user == null) throw Exception("No user logged in");
await _firestore.collection('notes').add({
  'text': text,
  'userId': user.uid,
});

// Refresh the list after adding
await fetchNotes();
} catch (e) {
debugPrint('Error adding note: $e');
rethrow;
}
}


Future<void> updateNote(String id, String newText) async {
try {
await _firestore.collection('notes').doc(id).update({'text': newText});
final index = _notes.indexWhere((note) => note.id == id);
if (index != -1) {
final oldNote = _notes[index];
_notes[index] = Note(id: id, text: newText, userId: oldNote.userId);
notifyListeners();
}
} catch (e) {
debugPrint('Error updating note: $e');
rethrow;
}
}


Future<void> deleteNote(String id) async {
try {
await _firestore.collection('notes').doc(id).delete();
_notes.removeWhere((note) => note.id == id);
notifyListeners();
} catch (e) {
debugPrint('Error deleting note: $e');
rethrow;
}
}
}