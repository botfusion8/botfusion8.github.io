import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  String? _imageUrl;


  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      _uploadImageToFirebase(_imageFile!);

    }
  }

  void addData() async {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('workspaces');

    await collectionReference.add({
      'name': _nameController.text,
      'url': _urlController.text,
      'image': _imageUrl,
    });

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Workspace added successfully'),));
  }

  Future<void> _uploadImageToFirebase(File image) async {
    try {
      // Create a unique file name for the image
      String fileName = DateTime
          .now()
          .millisecondsSinceEpoch
          .toString();
      // Upload the image to Firebase Storage
      Reference storageReference = FirebaseStorage.instance.ref().child(
          'images/$fileName');
      UploadTask uploadTask = storageReference.putFile(image);
      await uploadTask;
      // Retrieve the image URL
      String imageUrl = await storageReference.getDownloadURL();
      setState(() {
        _imageUrl = imageUrl;
      });
    } catch (e) {
      print('Error uploading image: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder( // <-- this line is used to make the border rounded
        borderRadius: BorderRadius.circular(12.0),
      ),
      title: const Text('Add Workflow'),
      contentPadding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0),
      // Adjust dialog width
      content: SizedBox(
        width: MediaQuery
            .of(context)
            .size
            .width / 3,
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
                _imageUrl != null ?
                Image.network(_imageUrl!,
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover)
                    : Container(),
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
            addData();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
