// import 'package:flutter/material.dart';
// import 'package:google_gemini/google_gemini.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// const apiKey = "AIzaSyDBlZs66H4pr9cMT2NycHKgzPZ7MulT0Ao";

// class AI extends StatefulWidget {
//   const AI({super.key});

//   @override
//   State<AI> createState() => _AIState();
// }

// class _AIState extends State<AI> {
//   bool loading = false;
//   final List<Map<String, String>> textChat = [];
//   final TextEditingController _textController = TextEditingController();
//   final ScrollController _controller = ScrollController();
//   final gemini = GoogleGemini(apiKey: apiKey);
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final User? user = FirebaseAuth.instance.currentUser; // Get current user

//   @override
//   void initState() {
//     super.initState();
//     loadChatHistory();
//   }

//   // Load chat history for the logged-in user
//   void loadChatHistory() async {
//     if (user == null) return; // No user is logged in

//     final chatDocs = await _firestore
//         .collection('users')
//         .doc(user!.email)
//         .collection('chat_history')
//         .orderBy('timestamp', descending: false)
//         .get();

//     setState(() {
//       for (var doc in chatDocs.docs) {
//         textChat.add({
//           "role": doc.data()['role'] ?? '',
//           "text": doc.data()['text'] ?? '',
//         });
//       }
//     });
//     scrollToTheEnd();
//   }

//   // Save a single message to Firestore under the user's email
//   void saveMessage(String role, String text) {
//     if (user == null) return; // No user is logged in

//     _firestore
//         .collection('users')
//         .doc(user!.email) // Document ID is the user's email
//         .collection('chat_history') // Sub-collection for chat history
//         .add({
//       'role': role,
//       'text': text,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   }

//   // Text input handler
//   void fromText({required String query}) {
//     setState(() {
//       loading = true;
//       textChat.add({"role": "User", "text": query});
//       saveMessage("User", query); // Save user message
//       _textController.clear();
//     });
//     scrollToTheEnd();

//     gemini.generateFromText(query).then((value) {
//       setState(() {
//         loading = false;
//         textChat.add({"role": "Jarvis AI", "text": value.text});
//         saveMessage("Jarvis AI", value.text); // Save AI response
//       });
//       scrollToTheEnd();
//     }).catchError((error) {
//       setState(() {
//         loading = false;
//         textChat.add({"role": "Jarvis AI", "text": "Error: ${error.toString()}"});
//         saveMessage("Jarvis AI", "Error: ${error.toString()}"); // Save error message
//       });
//       scrollToTheEnd();
//     });
//   }

//   void scrollToTheEnd() {
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (_controller.hasClients) {
//         _controller.jumpTo(_controller.position.maxScrollExtent);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.blueAccent,
//         title: const Text(
//           'AI Chat',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           // Chat List
//           Expanded(
//             child: ListView.builder(
//               controller: _controller,
//               itemCount: textChat.length,
//               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//               itemBuilder: (context, index) {
//                 final message = textChat[index];
//                 final isUser = message["role"] == "User";
//                 return Align(
//                   alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: 5),
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//                     decoration: BoxDecoration(
//                       color: isUser ? Colors.blue : Colors.grey[200],
//                       borderRadius: BorderRadius.only(
//                         topLeft: const Radius.circular(12),
//                         topRight: const Radius.circular(12),
//                         bottomLeft: isUser ? const Radius.circular(12) : Radius.zero,
//                         bottomRight: isUser ? Radius.zero : const Radius.circular(12),
//                       ),
//                     ),
//                     child: Text(
//                       message["text"]!,
//                       style: TextStyle(
//                         color: isUser ? Colors.white : Colors.black87,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           // Input Bar
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Row(
//               children: [
//                 // Text Input
//                 Expanded(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: TextField(
//                       controller: _textController,
//                       decoration: const InputDecoration(
//                         hintText: "Type a message...",
//                         contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                         border: InputBorder.none,
//                       ),
//                       maxLines: null,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 // Send Button
//                 CircleAvatar(
//                   backgroundColor: loading ? Colors.grey : Colors.blue,
//                   child: loading
//                       ? const SizedBox(
//                           width: 18,
//                           height: 18,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: Colors.white,
//                           ),
//                         )
//                       : IconButton(
//                           icon: const Icon(Icons.send, color: Colors.white),
//                           onPressed: loading
//                               ? null
//                               : () {
//                                   final text = _textController.text.trim();
//                                   if (text.isNotEmpty) {
//                                     fromText(query: text);
//                                   }
//                                 },
//                         ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }