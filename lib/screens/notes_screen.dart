import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notes_provider.dart';
import '../providers/auth_provider.dart';
import '../screens/add_edit_note_screen.dart';
import '../models/note_model.dart';

class NotesScreen extends StatefulWidget {
const NotesScreen({super.key});

@override
State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
@override
void initState() {
super.initState();
Future.microtask(() {
Provider.of<NotesProvider>(context, listen: false).fetchNotes();
});
}

Future<void> _confirmDelete(Note note, NotesProvider provider) async {
final confirm = await showDialog<bool>(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('Delete Note'),
    content: const Text('Are you sure you want to delete this note?'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: const Text('Cancel'),
      ),
      ElevatedButton(
        onPressed: () => Navigator.pop(context, true),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
        child: const Text('Delete'),
      ),
    ],
  ),
);

if (confirm == true) {
  try {
    await provider.deleteNote(note.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Note deleted")),
    );
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error deleting note: $e")),
    );
  }
}
}

@override
Widget build(BuildContext context) {
final notesProvider = Provider.of<NotesProvider>(context);
final authProvider = Provider.of<AuthProvider>(context);
final notes = notesProvider.notes;
final isLoading = notesProvider.isLoading;

return Scaffold(
  appBar: AppBar(
    title: const Text(
      'Your Notes',
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    ),
    centerTitle: true,
    actions: [
      IconButton(
        icon: const Icon(Icons.logout),
        tooltip: 'Logout',
        onPressed: () async {
          try {
            await authProvider.logout(context);
          } catch (e) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Logout failed: $e")),
            );
          }
        },
      ),
    ],
  ),
  body: isLoading
      ? const Center(child: CircularProgressIndicator())
      : notes.isEmpty
          ? const Center(child: Text('Nothing here yet—tap ➕ to add a note.'))
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final Note note = notes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(note.text, maxLines: 2, overflow: TextOverflow.ellipsis),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blueAccent),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddEditNoteScreen(note: note),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(note, notesProvider),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
  floatingActionButton: FloatingActionButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AddEditNoteScreen()),
      );
    },
    backgroundColor: Colors.indigo,
    foregroundColor: Colors.white,
    child: const Icon(Icons.add, size: 28),
  ),
);
}
}