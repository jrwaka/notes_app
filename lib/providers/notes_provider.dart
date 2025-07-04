import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note_model.dart';

class NotesProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Note> _notes = [];
  bool _isLoading = false;

  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> fetchNotes() async {
    _setLoading(true);
    try {
      final snapshot = await _firestore.collection('notes').get();
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
      final doc = await _firestore.collection('notes').add({'text': text});
      _notes.add(Note(id: doc.id, text: text));
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding note: $e');
    }
  }

  Future<void> updateNote(String id, String newText) async {
    try {
      await _firestore.collection('notes').doc(id).update({'text': newText});
      final index = _notes.indexWhere((note) => note.id == id);
      if (index != -1) {
        _notes[index] = Note(id: id, text: newText);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating note: $e');
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await _firestore.collection('notes').doc(id).delete();
      _notes.removeWhere((note) => note.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting note: $e');
    }
  }
}
