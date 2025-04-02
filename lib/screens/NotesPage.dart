import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final dbRef = FirebaseDatabase.instance.ref().child("notes");
  List<Map<String, dynamic>> notesList = [];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  void fetchNotes() {
    dbRef.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data == null) {
        setState(() => notesList = []);
        return;
      }

      final notesMap = Map<String, dynamic>.from(data as Map);
      final tempList = notesMap.entries.map((entry) {
        final noteData = Map<String, dynamic>.from(entry.value);
        return {
          'id': entry.key,
          'title': noteData['title'],
          'content': noteData['content'],
          'timestamp': noteData['timestamp'],
        };
      }).toList();

      setState(() => notesList = tempList);
    });
  }

  void addOrEditNote({Map<String, dynamic>? note}) {
    final titleController = TextEditingController(text: note?['title']);
    final contentController = TextEditingController(text: note?['content']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(note == null ? "Add Note" : "Edit Note"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: contentController, decoration: const InputDecoration(labelText: 'Content')),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () {
                final noteData = {
                  'title': titleController.text,
                  'content': contentController.text,
                  'timestamp': DateTime.now().toIso8601String()
                };
                if (note == null) {
                  dbRef.push().set(noteData);
                } else {
                  dbRef.child(note['id']).update(noteData);
                }
                Navigator.pop(context);
              },
              child: const Text("Save")),
          if (note != null)
            TextButton(
                onPressed: () {
                  dbRef.child(note['id']).remove();
                  Navigator.pop(context);
                },
                child: const Text("Delete", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Notes")),
      body: notesList.isEmpty
          ? const Center(child: Text("No notes yet. Add one!"))
          : ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (_, index) {
                final note = notesList[index];
                return ListTile(
                  title: Text(note['title']),
                  subtitle: Text(note['content']),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => addOrEditNote(note: note),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addOrEditNote(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
