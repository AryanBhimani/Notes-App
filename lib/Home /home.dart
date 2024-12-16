import 'package:flutter/material.dart';
import 'package:notes_app/Home%20/ai.dart';
import 'package:notes_app/Home%20/notes.dart';
import 'package:notes_app/Login%20/login.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Notes App",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF274a99),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer Header
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF274a99),
              ),
              child: Center(
                child: Text(
                  "Notes App",
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.white,
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => const textOnly()));
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
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false, // Clears the navigation stack after logout
                );
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          "Welcome to Notes App!",
          style: TextStyle(fontSize: 20.0),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => textOnly()));
        },
        backgroundColor: const Color(0xFF274a99), // Custom color
        child: const Icon(Icons.add, color: Colors.white), // Icon with white color
      ),
    );
  }
}
