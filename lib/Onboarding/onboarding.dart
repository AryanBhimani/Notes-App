import 'package:flutter/material.dart';
import 'package:notes_app/Login%20/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

// OnboardingInfo class
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

// OnboardingData class
class OnboardingData {
  List<OnboardingInfo> items = [
    OnboardingInfo(
      title: "Unlimited Questions",
      description: "High-quality questions and quizzes with hundreds of tests",
      image: "assets/onboarding1.gif",
    ),
    OnboardingInfo(
      title: "Interesting stories",
      description: "Reading top stories to learn and enhance your knowledge",
      image: "assets/onboarding2.gif",
    ),
    OnboardingInfo(
      title: "Reading Books",
      description: "Reading new books with top content and excellent stories",
      image: "assets/onboarding3.gif",
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

  // Check if onboarding is completed
  Future<void> _checkOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    bool isOnboardingCompleted = prefs.getBool('isOnboardingCompleted') ?? false;

    if (isOnboardingCompleted) {
      // Navigate to the login page if onboarding is completed
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  // Set onboarding as completed
  Future<void> _setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isOnboardingCompleted', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          body(),
          buildDots(),
          button(),
        ],
      ),
    );
  }

  // Body
  Widget body() {
    return Expanded(
      child: Center(
        child: PageView.builder(
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
                  // Images
                  Image.asset(controller.items[currentIndex].image),

                  const SizedBox(height: 15),
                  // Titles
                  Text(
                    controller.items[currentIndex].title,
                    style: const TextStyle(
                      fontSize: 25,
                      color: Color(0xFF274a99),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  // Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      controller.items[currentIndex].description,
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Dots
  Widget buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(controller.items.length, (index) {
        return AnimatedContainer(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: currentIndex == index ? Color(0xFF274a99) : Colors.grey,
          ),
          height: 7,
          width: currentIndex == index ? 30 : 7,
          duration: const Duration(milliseconds: 700),
        );
      }),
    );
  }

  // Button
  Widget button() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      width: MediaQuery.of(context).size.width * .9,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xFF274a99),
      ),
      child: TextButton(
        onPressed: () {
          setState(() {
            if (currentIndex != controller.items.length - 1) {
              currentIndex++;
            } else {
              // Mark onboarding as completed and navigate to login page
              _setOnboardingCompleted();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            }
          });
        },
        child: Text(
          currentIndex == controller.items.length - 1
              ? "Get started"
              : "Continue",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
