import 'dart:typed_data';
import 'package:chatbot_text_tool/service/user_service.dart';
import 'package:chatbot_text_tool/utils/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class WorkflowDialog extends StatefulWidget {
  const WorkflowDialog({super.key});

  @override
  _WorkflowDialogState createState() => _WorkflowDialogState();
}

class _WorkflowDialogState extends State<WorkflowDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  Uint8List? _imageBytes;
  String? _imageUrl;

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.bytes != null) {
      final fileBytes = result.files.single.bytes!;
      final fileName = result.files.single.name;

      setState(() {
        _imageBytes = fileBytes;
      });

      _uploadImageToFirebase(fileBytes, fileName);
    }
  }

  void addData() async {
    String name = _nameController.text.trim();
    String url = _urlController.text.trim();

    if (name.isEmpty || url.isEmpty) {
      context.showCustomSnackBar('Please provide both name and URL');
      return;
    }

    CollectionReference collectionReference = FirebaseFirestore.instance.collection('workspaces');

    await collectionReference.add({
      'userRef': UserService().getUserReference(),
      'name': name,
      'url': url,
      'image': _imageUrl,
    });

    Navigator.pop(context);
    context.showCustomSnackBar('Workspace added successfully');
  }

  Future<void> _uploadImageToFirebase(Uint8List fileBytes, String fileName) async {
    try {
      // Upload the image to Firebase Storage
      Reference storageReference = FirebaseStorage.instance.ref().child('images/$fileName');
      UploadTask uploadTask = storageReference.putData(fileBytes);
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      title: const Text('Create Workspace'),
      contentPadding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0),
      content: SizedBox(
        width: MediaQuery.of(context).size.width / 3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Workspace name'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _urlController,
              decoration: const InputDecoration(labelText: 'URL'),
            ),
            const SizedBox(height: 16),
            _imageBytes != null
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Selected Image:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _imageUrl != null
                    ? Image.network(_imageUrl!, height: 100, width: double.infinity, fit: BoxFit.cover)
                    : Container(),
                const SizedBox(height: 16),
              ],
            )
                : const Text('No image selected'),
            const SizedBox(height: 16),
            InkWell(
              onTap: _pickImage,
              child: Container(
                height: 35,
                alignment: Alignment.center,
                width: 150,
                decoration: BoxDecoration(
                  //0xFF39D2C0
                  color: const Color(0xFF39D2C0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: const Offset(
                          0, 1), // changes position of shadow
                    ),
                  ],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                padding: const EdgeInsets.all(5),
                child: const Text(
                  'Select Image',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
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
        InkWell(
          onTap: addData,
          child: Container(
            height: 30,
            alignment: Alignment.center,
            width: 80,
            decoration: BoxDecoration(
              //0xFF39D2C0
              color: const Color(0xFF39D2C0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: const Offset(
                      0, 1), // changes position of shadow
                ),
              ],
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            padding: const EdgeInsets.all(5),
            child: const Text(
              'Save',
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
