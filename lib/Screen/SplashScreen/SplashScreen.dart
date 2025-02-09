// ignore: file_names
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_app/Screen/Home%20/home.dart';
import 'package:notes_app/Screen/Login%20and%20Sign%20Up/login.dart';
import 'package:notes_app/Services/Button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:notes_app/Services/Colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const Home()));
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const OnboardingPage()));
      }
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class OnboardingInfo {
  final String title;
  final String description;
  final String image;

  OnboardingInfo({
    required this.title,
    required this.description,
    required this.image,
  });
}

class OnboardingData {
  List<OnboardingInfo> items = [
    OnboardingInfo(
      title: "NoteEase",
      description: "Capture, sync, and organize your notes in real-time.",
      image: "assets/onboarding1.png",
    ),
    OnboardingInfo(
      title: "MyNotes",
      description: "Your notes, always synced and accessible, wherever you are.",
      image: "assets/onboarding2.png",
    ),
    OnboardingInfo(
      title: "QuickNotes",
      description: "Effortless note management with real-time syncing and cloud storage",
      image: "assets/onboarding3.png",
    ),
  ];
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final controller = OnboardingData();
  final pageController = PageController();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _checkOnboardingCompleted();
  }

  Future<void> _checkOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    bool isOnboardingCompleted = prefs.getBool('isOnboardingCompleted') ?? false;

    if (isOnboardingCompleted) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));
    }
  }

  Future<void> _setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isOnboardingCompleted', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageController,
              onPageChanged: (value) {
                setState(() {
                  currentIndex = value;
                });
              },
              itemCount: controller.items.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(controller.items[index].image, height: 300),
                      const SizedBox(height: 25),
                      Text(
                        controller.items[index].title,
                        style: const TextStyle(
                          fontSize: 28,
                          color: yellow,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          controller.items[index].description,
                          style: const TextStyle(color: grey, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          buildDots(),
          Button(
            label: currentIndex == controller.items.length - 1 ? "Get Started" : "Continue",
            onPressed: () {
              if (currentIndex != controller.items.length - 1) {
                pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
              } else {
                _setOnboardingCompleted();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              }
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(controller.items.length, (index) {
        return AnimatedContainer(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          height: 10,
          width: currentIndex == index ? 30 : 10,
          decoration: BoxDecoration(
            color: currentIndex == index ? yellow : grey,
            borderRadius: BorderRadius.circular(5),
          ),
          duration: const Duration(milliseconds: 300),
        );
      }),
    );
  }
}