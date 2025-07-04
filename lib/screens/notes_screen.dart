import 'package:flutter/material.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notes = <String>[]; // Replace with provider later

    return Scaffold(
      appBar: AppBar(title: const Text('My Notes')),
      body: notes.isEmpty
          ? const Center(child: Text('Nothing here yet—tap ➕ to add a note.'))
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return ListTile(
                  title: Text(note),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {},
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_edit_note');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
