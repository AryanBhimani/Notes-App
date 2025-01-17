import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_app/Screen/Home%20/AI.dart';
import 'package:notes_app/Screen/Home%20/profile.dart';
import 'package:notes_app/Screen/Login%20/login.dart';
import '../Services/note.dart';
import '../Services/firestore_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFCA28),
        actions: [
          IconButton(
      icon: const Icon(
        Icons.logout,color: Colors.black),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pushReplacement(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(builder: (context) => const Login()),  // Navigate to Login after sign out
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFFFCA28),
              ),
              child: Center(
                child: Text(
                  "Notes App",
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person,color: Colors.black),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const profile()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.text_snippet,color: Colors.black),
              title: const Text('Text Only'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TextOnly()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout,color: Colors.black),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Login(),  // Replace with the Profile screen
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<List<Note>>(
        stream: _firestoreService.fetchNotes(user!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No notes yet. Add some!"));
          }

          final notes = snapshot.data!;

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return ListTile(
                title: Text(note.title),
                subtitle: Text(note.content),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await _firestoreService.deleteNote(user.uid, note.id);
                  },
                ),
                onTap: () {
                  titleController.text = note.title;
                  contentController.text = note.content;
                  _showNoteDialog(user.uid, note: note);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          titleController.clear();
          contentController.clear();
          _showNoteDialog(user.uid);
        },
        backgroundColor: const Color(0xFFFFCA28),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  void _showNoteDialog(String userId, {Note? note}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(note == null ? "Add Note" : "Edit Note",
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: "Content"),
              maxLines: 5,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final title = titleController.text.trim();
              final content = contentController.text.trim();

              if (title.isEmpty || content.isEmpty) return;

              if (note == null) {
                await _firestoreService.addNote(
                  userId,
                  Note(id: "", title: title, content: content),
                );
              } else {
                await _firestoreService.updateNote(
                  userId,
                  Note(id: note.id, title: title, content: content),
                );
              }

              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
            child: const Text("Save",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
