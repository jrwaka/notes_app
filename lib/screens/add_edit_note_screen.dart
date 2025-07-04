import 'package:flutter/material.dart';

class AddEditNoteScreen extends StatelessWidget {
  final String? existingNoteText;
  final String? noteId;

  const AddEditNoteScreen({super.key, this.existingNoteText, this.noteId});

  @override
  Widget build(BuildContext context) {
    final noteController = TextEditingController(text: existingNoteText);

    return Scaffold(
      appBar: AppBar(
        title: Text(noteId == null ? 'Add Note' : 'Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: noteController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Enter your note...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final text = noteController.text.trim();
                if (text.isNotEmpty) {}
              },
              child: Text(noteId == null ? 'Add Note' : 'Update Note'),
            ),
          ],
        ),
      ),
    );
  }
}
