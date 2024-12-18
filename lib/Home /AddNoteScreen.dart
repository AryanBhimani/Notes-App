import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddNoteScreen extends StatefulWidget {
  final DocumentSnapshot? note; // For editing, this will hold the note document.

  const AddNoteScreen({Key? key, this.note}) : super(key: key);

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      // Populate fields if editing an existing note.
      _titleController.text = widget.note!['title'];
      _contentController.text = widget.note!['content'];
    }
  }

  void _saveNote() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Title and Content cannot be empty.')),
      );
      return;
    }

    try {
      if (widget.note == null) {
        // Add a new note.
        await _firestore.collection('notes').add({
          'title': _titleController.text,
          'content': _contentController.text,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        // Update an existing note.
        await _firestore.collection('notes').doc(widget.note!.id).update({
          'title': _titleController.text,
          'content': _contentController.text,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
      Navigator.pop(context); // Close the screen after saving.
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving note: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Add Note' : 'Edit Note'),
        backgroundColor: const Color(0xFFFFCA28),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _saveNote,
              child: Text(widget.note == null ? 'Add Note' : 'Update Note'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFCA28),
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
