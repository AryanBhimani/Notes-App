// // ignore: file_names
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:notes_app/Screen/Home%20/home.dart';
// import 'package:notes_app/Screen/Login%20and%20Sign%20Up/login.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Future.delayed(Duration.zero, () {
//       final User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const Home()));
//       } else {
//         Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const OnboardingPage()));
//       }
//     });
//     return const Scaffold(
//       body: Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }

// class OnboardingInfo {
//   final String title;
//   final String description;
//   final String image;

//   OnboardingInfo({
//     required this.title,
//     required this.description,
//     required this.image,
//   });
// }

// // OnboardingData class
// class OnboardingData {
//   List<OnboardingInfo> items = [
//     OnboardingInfo(
//       title: "NoteEase",
//       description: "Capture, sync, and organize your notes in real-time.",
//       image: "assets/onboarding1.png",
//     ),
//     OnboardingInfo(
//       title: "MyNotes",
//       description: "Your notes, always synced and accessible, wherever you are.",
//       image: "assets/onboarding2.png",
//     ),
//     OnboardingInfo(
//       title: "QuickNotes",
//       description: "Effortless note management with real-time syncing and cloud storage",
//       image: "assets/onboarding3.png",
//     ),
//   ];
// }

// class OnboardingPage extends StatefulWidget {
//   const OnboardingPage({super.key});

//   @override
//   State<OnboardingPage> createState() => _OnboardingPageState();
// }

// class _OnboardingPageState extends State<OnboardingPage> {
//   final controller = OnboardingData();
//   final pageController = PageController();
//   int currentIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _checkOnboardingCompleted();
//   }

//   // Check if onboarding is completed
//   Future<void> _checkOnboardingCompleted() async {
//     final prefs = await SharedPreferences.getInstance();
//     bool isOnboardingCompleted = prefs.getBool('isOnboardingCompleted') ?? false;

//     if (isOnboardingCompleted) {
//       Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const Login()));
//     }
//   }

//   // Set onboarding as completed
//   Future<void> _setOnboardingCompleted() async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setBool('isOnboardingCompleted', true);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           body(),
//           buildDots(),
//           button(),
//         ],
//       ),
//     );
//   }

//   // Body
//   Widget body() {
//     return Expanded(
//       child: Center(
//         child: PageView.builder(
//           onPageChanged: (value) {
//             setState(() {
//               currentIndex = value;
//             });
//           },
//           itemCount: controller.items.length,
//           itemBuilder: (context, index) {
//             return Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Images
//                   Image.asset(controller.items[currentIndex].image),

//                   const SizedBox(height: 15),
//                   // Titles
//                   Text(
//                     controller.items[currentIndex].title,
//                     style: const TextStyle(
//                       fontSize: 25,
//                       color: Color(0xFFFFCA28),
//                       fontWeight: FontWeight.bold,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),

//                   // Description
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 25),
//                     child: Text(
//                       controller.items[currentIndex].description,
//                       style: const TextStyle(color: Colors.grey, fontSize: 16),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   // Dots
//   Widget buildDots() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(controller.items.length, (index) {
//         return AnimatedContainer(
//           margin: const EdgeInsets.symmetric(horizontal: 2),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(50),
//             color: currentIndex == index ? const Color(0xFFFFCA28) : Colors.grey,
//           ),
//           height: 7,
//           width: currentIndex == index ? 30 : 7,
//           duration: const Duration(milliseconds: 700),
//         );
//       }),
//     );
//   }

//   // Button
//   Widget button() {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 20),
//       width: MediaQuery.of(context).size.width * .9,
//       height: 55,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         color: const Color(0xFFFFCA28),
//       ),
//       child: TextButton(
//         onPressed: () {
//           setState(() {
//             if (currentIndex != controller.items.length - 1) {
//               currentIndex++;
//             } else {
//               // Mark onboarding as completed and navigate to login page
//               _setOnboardingCompleted();
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const Login()),
//               );
//             }
//           });
//         },
//         child: Text(
//           currentIndex == controller.items.length - 1
//               ? "Get started"
//               : "Continue",
//           style: const TextStyle(color: Colors.white),
//         ),
//       ),
//     );
//   }
// }



// // ignore: file_names
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:notes_app/Screen/Home%20/home.dart';
// import 'package:notes_app/Screen/Login%20and%20Sign%20Up/login.dart';
// import 'package:notes_app/Screen/Services/Button.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Future.delayed(Duration.zero, () {
//       final User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
//       } else {
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OnboardingPage()));
//       }
//     });
//     return const Scaffold(
//       body: Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }

// class OnboardingInfo {
//   final String title;
//   final String description;
//   final String image;

//   OnboardingInfo({
//     required this.title,
//     required this.description,
//     required this.image,
//   });
// }

// class OnboardingData {
//   List<OnboardingInfo> items = [
//     OnboardingInfo(
//       title: "NoteEase",
//       description: "Capture, sync, and organize your notes in real-time.",
//       image: "assets/onboarding1.png",
//     ),
//     OnboardingInfo(
//       title: "MyNotes",
//       description: "Your notes, always synced and accessible, wherever you are.",
//       image: "assets/onboarding2.png",
//     ),
//     OnboardingInfo(
//       title: "QuickNotes",
//       description: "Effortless note management with real-time syncing and cloud storage",
//       image: "assets/onboarding3.png",
//     ),
//   ];
// }

// class OnboardingPage extends StatefulWidget {
//   const OnboardingPage({super.key});

//   @override
//   State<OnboardingPage> createState() => _OnboardingPageState();
// }

// class _OnboardingPageState extends State<OnboardingPage> {
//   final controller = OnboardingData();
//   final pageController = PageController();
//   int currentIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _checkOnboardingCompleted();
//   }

//   Future<void> _checkOnboardingCompleted() async {
//     final prefs = await SharedPreferences.getInstance();
//     bool isOnboardingCompleted = prefs.getBool('isOnboardingCompleted') ?? false;
    
//     if (isOnboardingCompleted) {
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));
//     }
//   }

//   Future<void> _setOnboardingCompleted() async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setBool('isOnboardingCompleted', true);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           body(),
//           buildDots(),
//           Button(
//             label: currentIndex == controller.items.length - 1 ? "Get started" : "Continue",
//             onPressed: () {
//               setState(() {
//                 if (currentIndex != controller.items.length - 1) {
//                   currentIndex++;
//                   pageController.animateToPage(
//                     currentIndex,
//                     duration: const Duration(milliseconds: 300),
//                     curve: Curves.easeInOut,
//                   );
//                 } else {
//                   _setOnboardingCompleted();
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => const Login()),
//                   );
//                 }
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget body() {
//     return Expanded(
//       child: Center(
//         child: PageView.builder(
//           controller: pageController,
//           onPageChanged: (value) {
//             setState(() {
//               currentIndex = value;
//             });
//           },
//           itemCount: controller.items.length,
//           itemBuilder: (context, index) {
//             return Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset(controller.items[index].image),
//                   const SizedBox(height: 15),
//                   Text(
//                     controller.items[index].title,
//                     style: const TextStyle(
//                       fontSize: 25,
//                       color: Color(0xFFFFCA28),
//                       fontWeight: FontWeight.bold,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 25),
//                     child: Text(
//                       controller.items[index].description,
//                       style: const TextStyle(color: Colors.grey, fontSize: 16),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget buildDots() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(controller.items.length, (index) {
//         return AnimatedContainer(
//           margin: const EdgeInsets.symmetric(horizontal: 2),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(50),
//             color: currentIndex == index ? const Color(0xFFFFCA28) : Colors.grey,
//           ),
//           height: 7,
//           width: currentIndex == index ? 30 : 7,
//           duration: const Duration(milliseconds: 700),
//         );
//       }),
//     );
//   }
// }



// ignore: file_names
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_app/Screen/Home%20/home.dart';
import 'package:notes_app/Screen/Login%20and%20Sign%20Up/login.dart';
import 'package:notes_app/Screen/Services/Button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:notes_app/Screen/Services/Colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OnboardingPage()));
      }
    });
    return Scaffold(
      backgroundColor: yellow,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', height: 100),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: black),
          ],
        ),
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