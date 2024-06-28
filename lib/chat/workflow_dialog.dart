import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class WorkflowDialog extends StatefulWidget {
  const WorkflowDialog({super.key});

  @override
  _WorkflowDialogState createState() => _WorkflowDialogState();
}

class _WorkflowDialogState extends State<WorkflowDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveWorkflow() async {
    String name = _nameController.text;
    String url = _urlController.text;

    // Save data to Firebase
/*    await _database.push().set({
      'name': name,
      'url': url,
    });*/

    // Clear controllers
    _nameController.clear();
    _urlController.clear();

    // Optionally, you can also clear _imageFile or reset any other state variables
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder( // <-- this line is used to make the border rounded
        borderRadius: BorderRadius.circular(12.0),
      ),
      title: const Text('Add Workflow'),
      contentPadding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0), // Adjust dialog width
      content: SizedBox(
        width: MediaQuery.of(context).size.width/3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Workflow name'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _urlController,
              decoration: const InputDecoration(labelText: 'URL'),
            ),
            const SizedBox(height: 16),

            _imageFile != null ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Selected Image:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Image.file(_imageFile!, height: 100, width: double.infinity, fit: BoxFit.cover),
                const SizedBox(height: 16),
              ],
            ) : const Text('No image selected'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Select Image'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            String name = _nameController.text;
            String url = _urlController.text;
            // You can process and save your data here
            _saveWorkflow();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
