import 'package:flutter/material.dart';
import 'package:notes_app/Home%20/AI-Image.dart';
import 'package:notes_app/Home%20/AI.dart';
import 'package:notes_app/Home%20/profile.dart';
import 'package:notes_app/Home%20/AddNoteScreen.dart';
import 'package:notes_app/Login%20/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatelessWidget {
  Home({super.key});
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Notes App",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color(0xFFFFCA28),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer Header
            DrawerHeader(
              decoration: const BoxDecoration(
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
            // List Items
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const profile()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.text_snippet),
              title: const Text('Text Only'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const textOnly()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Text with Image'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const textWithImage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('LogOut'),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                  (route) => false, // Clears the navigation stack after logout
                );
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('notes').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final notes = snapshot.data!.docs;
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return ListTile(
                title: Text(note['title']),
                subtitle: Text(note['content']),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNoteScreen()),
          );
        },
        backgroundColor: Color(0xFFFFCA28),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
