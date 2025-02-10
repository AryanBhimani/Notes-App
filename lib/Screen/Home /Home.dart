// // ignore_for_file: file_names

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:lottie/lottie.dart';
// import 'package:notes_app/Screen/Home%20/Profile.dart';
// import 'package:notes_app/Screen/Login%20and%20Sign%20Up/login.dart';
// import 'package:notes_app/Services/Colors.dart';
// import '../../Services/note.dart';
// import '../../Services/firestore_service.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirestoreService _firestoreService = FirestoreService();

//   TextEditingController titleController = TextEditingController();
//   TextEditingController contentController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final user = _auth.currentUser;
//     return Scaffold(
//       backgroundColor: white,
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: yellow,
//         foregroundColor: black,
//         title: const Text("Notes"),
//         leading: IconButton(
//           icon: const Icon(Icons.account_circle, size: 28),
//           onPressed: () {
//             Navigator.push(context, MaterialPageRoute(builder: (context) => const Profile()));
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout_outlined, size: 28),
//             onPressed: () async {
//               await FirebaseAuth.instance.signOut();
//               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           const SizedBox(height: 20),
//           Expanded(child: _buildNotesList(user)),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           titleController.clear();
//           contentController.clear();
//           _showNoteDialog(user!.uid);
//         },
//         backgroundColor: yellow,
//         child: Lottie.asset('assets/ai.json', width: 40),
//       ),
//     );
//   }

//   Widget _buildNotesList(User? user) {
//     return StreamBuilder<List<Note>>(
//       stream: _firestoreService.fetchNotes(user!.uid),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return const Center(child: Text("No notes yet. Add some!"));
//         }

//         final notes = snapshot.data!;

//         return ListView.builder(
//           itemCount: notes.length,
//           itemBuilder: (context, index) {
//             final note = notes[index];
//             return Card(
//               margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//               child: ListTile(
//                 title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
//                 subtitle: Text(note.content, maxLines: 2, overflow: TextOverflow.ellipsis),
//                 trailing: IconButton(
//                   icon: const Icon(Icons.delete, color: Colors.redAccent),
//                   onPressed: () async {
//                     await _firestoreService.deleteNote(user.uid, note.id);
//                   },
//                 ),
//                 onTap: () {
//                   titleController.text = note.title;
//                   contentController.text = note.content;
//                   _showNoteDialog(user.uid, note: note);
//                 },
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   void _showNoteDialog(String userId, {Note? note}) {
//     final titleController = TextEditingController(text: note?.title);
//     final contentController = TextEditingController(text: note?.content);

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
//       ),
//       backgroundColor: Colors.white,
//       builder: (context) => Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//         ),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 height: 4,
//                 width: 40,
//                 margin: const EdgeInsets.only(bottom: 20),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               Text(
//                 note == null ? "Add Note" : "Edit Note",
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: titleController,
//                 decoration: InputDecoration(
//                   labelText: "Title",
//                   labelStyle: TextStyle(color: Colors.grey[700]),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: const BorderSide(color: red),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 15),
//               TextField(
//                 controller: contentController,
//                 decoration: InputDecoration(
//                   labelText: "Content",
//                   labelStyle: TextStyle(color: Colors.grey[700]),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: const BorderSide(color: red),
//                   ),
//                 ),
//                 maxLines: 5,
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   ElevatedButton.icon(
//                     onPressed: () => Navigator.pop(context),
//                     icon: const Icon(Icons.close, color: Colors.white),
//                     label: const Text("Cancel" , style: TextStyle(color: black)),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                   ElevatedButton.icon(
//                     onPressed: () async {
//                       final title = titleController.text.trim();
//                       final content = contentController.text.trim();

//                       if (title.isEmpty || content.isEmpty) return;

//                       if (note == null) {
//                         await _firestoreService.addNote(
//                           userId,
//                           Note(id: "", title: title, content: content),
//                         );
//                       } else {
//                         await _firestoreService.updateNote(
//                           userId,
//                           Note(id: note.id, title: title, content: content),
//                         );
//                       }
//                       Navigator.pop(context);
//                     },
//                     icon: const Icon(Icons.save, color: Colors.white),
//                     label: const Text("Save", style: TextStyle(color: black)),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:notes_app/Screen/Home%20/Profile.dart';
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
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initAdMob();
  }

  void _initAdMob() {
    MobileAds.instance.initialize();
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-4362785321861304/1108273971', 
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: yellow,
        foregroundColor: black,
        title: const Text("Notes"),
        leading: IconButton(
          icon: const Icon(Icons.account_circle, size: 28),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const Profile()));
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined, size: 28),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(child: _buildNotesList(user)),
          if (_isBannerAdReady)
            Container(
              height: _bannerAd.size.height.toDouble(),
              width: _bannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd),
            ),
        ],
      ),
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

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4,
                width: 40,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                note == null ? "Add Note" : "Edit Note",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: red),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: contentController,
                decoration: InputDecoration(
                  labelText: "Content",
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: red),
                  ),
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                    label: const Text("Cancel", style: TextStyle(color: black)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
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
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text("Save", style: TextStyle(color: black)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
