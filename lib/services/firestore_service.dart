import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new note
  Future<void> addNote(String userId, Note note) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .add(note.toMap());
  }

  // Fetch all notes for a specific user
  Stream<List<Note>> fetchNotes(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Note.fromMap(doc.id, doc.data()))
        .toList());
  }

  // Update a note
  Future<void> updateNote(String userId, Note note) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(note.id)
        .update(note.toMap());
  }

  // Delete a note
  Future<void> deleteNote(String userId, String noteId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(noteId)
        .delete();
  }
}
