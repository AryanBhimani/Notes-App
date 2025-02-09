// ignore: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_gemini/google_gemini.dart';
import 'package:notes_app/Services/Colors.dart';

const apiKey = "AIzaSyDBlZs66H4pr9cMT2NycHKgzPZ7MulT0Ao";

class TextOnly extends StatefulWidget {
  const TextOnly({super.key});

  @override
  State<TextOnly> createState() => _TextOnlyState();
}

class _TextOnlyState extends State<TextOnly> {
  bool loading = false;
  List textChat = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _controller = ScrollController();
  final User? user = FirebaseAuth.instance.currentUser;
  

  // Create Gemini Instance
  final gemini = GoogleGemini(
    apiKey: apiKey,
  );

  // Text only input
  void fromText({required String query}) {
    setState(() {
      loading = true;
      textChat.add({
        "role": "${user?.email}",
        "text": query,
      });
      _textController.clear();
    });
    scrollToTheEnd();

    gemini.generateFromText(query).then((value) {
      setState(() {
        loading = false;
        textChat.add({
          "role": "Notes",
          "text": value.text,
        });
      });
      scrollToTheEnd();
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
        textChat.add({
          "role": "Notes",
          "text": error.toString(),
        });
      });
      scrollToTheEnd();
    });
  }

  void scrollToTheEnd() {
    _controller.jumpTo(_controller.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: yellow,
        title: const Text(
          'AI Chat',
          style: TextStyle(
            color: black,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _controller,
              itemCount: textChat.length,
              padding: const EdgeInsets.only(bottom: 20),
              itemBuilder: (context, index) {
                return ListTile(
                  isThreeLine: true,
                  leading: CircleAvatar(
                    child: Text(textChat[index]["role"].substring(0, 1)),
                  ),
                  title: Text(textChat[index]["role"]),
                  subtitle: SelectableText(
                    textChat[index]["text"],  // Make the text selectable
                    style: const TextStyle(color: black),
                  ),
                );
              },
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.0),
              border: Border.all(color: black),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: black,
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                IconButton(
                  icon: loading
                      ? const CircularProgressIndicator()
                      : const Icon(Icons.send, color: black),
                  onPressed: () {
                    fromText(query: _textController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
