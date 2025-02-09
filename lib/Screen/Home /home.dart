import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:notes_app/Screen/Home%20/AI.dart';
import 'package:notes_app/Screen/Home%20/profile.dart';
import 'package:notes_app/Screen/Login%20and%20Sign%20Up/login.dart';
import 'package:notes_app/Services/Colors.dart';
import '../../Services/note.dart';
import '../../Services/firestore_service.dart';

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
        title: const Text("Notes", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: yellow,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const Login()));
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: _buildNotesList(user),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          titleController.clear();
          contentController.clear();
          _showNoteDialog(user!.uid);
        },
        backgroundColor: yellow,
        child: Lottie.asset('assets/ai.json', width: 40),
      ),
    );
  }
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: yellow),
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
          _buildDrawerItem(Icons.person, 'Profile', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const profile()));
          }),
          _buildDrawerItem(Icons.text_snippet, 'Text Only', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const TextOnly()));
          }),
          _buildDrawerItem(Icons.logout, 'Logout', () async {
            await _auth.signOut();
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const Login()));
          }),
        ],
      ),
    );
  }
  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      onTap: onTap,
    );
  }
  Widget _buildNotesList(User? user) {
    return StreamBuilder<List<Note>>(
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
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: ListTile(
                title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(note.content, maxLines: 2, overflow: TextOverflow.ellipsis),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () async {
                    await _firestoreService.deleteNote(user.uid, note.id);
                  },
                ),
                onTap: () {
                  titleController.text = note.title;
                  contentController.text = note.content;
                  _showNoteDialog(user.uid, note: note);
                },
              ),
            );
          },
        );
      },
    );
  }

  void _showNoteDialog(String userId, {Note? note}) {
    final titleController = TextEditingController(text: note?.title);
    final contentController = TextEditingController(text: note?.content);

    showDialog(
      context: context,
      builder: (context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: yellow,
          title: Text(
            note == null ? "Add Note" : "Edit Note",
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.save, color: Colors.green),
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
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: TextField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    labelText: "Content",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                  expands: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}