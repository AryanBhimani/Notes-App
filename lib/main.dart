import 'package:flutter/material.dart';
import 'package:notes_app/Onboarding/SplashScreen.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Notes App',
      debugShowCheckedModeBanner: false,
      // home: OnboardingPage(),
      home: SplashScreen(),
    );
  }
}