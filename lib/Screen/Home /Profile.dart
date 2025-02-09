// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_app/Screen/Home%20/ProfileEdit.dart';
import 'package:notes_app/Screen/Login%20and%20Sign%20Up/login.dart';
import 'package:notes_app/Services/Button.dart';
import 'package:notes_app/Services/Colors.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: yellow,
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: yellow.withOpacity(0.8),
              child: Text(
                user.displayName != null && user.displayName!.isNotEmpty ? user.displayName![0].toUpperCase() : '?',
                style: const TextStyle(fontSize: 50, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              user.displayName ?? "No Name Provided",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "User Name:",
                    style: TextStyle(fontSize: 16, color: black),
                  ),
                  Flexible(
                    child: Text(
                      user.displayName ?? "No Name Provided",
                      style: const TextStyle(fontSize: 14, color: black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "User Email:",
                    style: TextStyle(fontSize: 16, color: black),
                  ),
                  Flexible(
                    child: Text(
                      user.email ?? "No Email Provided",
                      style: const TextStyle(fontSize: 14, color: black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Button(label: "Edit Profile", 
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileEdit()));
              },
            ),
            Button(label: "Log Out", 
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}