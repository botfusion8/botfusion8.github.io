import 'dart:typed_data';
import 'package:chatbot_text_tool/presentation/common/color_picker.dart';
import 'package:chatbot_text_tool/service/user_service.dart';
import 'package:chatbot_text_tool/utils/captalize_string.dart';
import 'package:chatbot_text_tool/utils/custom_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../common/nothing_to_show.dart';

class WorkflowDialog extends StatefulWidget {
  String? name;
  String? url;
  String? workspaceColor;
  String? workspaceId;
  String? tokenHeader;

  WorkflowDialog({
    super.key,
    this.name,
    this.url,
    this.workspaceColor,
    this.workspaceId,
    this.tokenHeader,
  });

  @override
  _WorkflowDialogState createState() => _WorkflowDialogState();
}

class _WorkflowDialogState extends State<WorkflowDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _tokenHeader = TextEditingController();
  final TextEditingController _confirmDeleteController =
      TextEditingController();

  Color selectedWorkspaceColor = Colors.grey.withAlpha(70);
  Uint8List? _imageBytes;
  String? _imageUrl;
  String? _btnText;
  String? dialogHeaderText;
  bool _showConfirmDeleteField = false;

  @override
  void initState() {
    _nameController.text = widget.name ?? "";
    _urlController.text = widget.url ?? "";

    if (widget.workspaceId?.isNotEmpty == true &&
        widget.url?.isNotEmpty == true) {
      _btnText = "Update";
    } else {
      _btnText = "Save";
    }

    if (widget.workspaceColor != null) {
      setState(() {
        selectedWorkspaceColor = Color(int.parse(widget.workspaceColor!));
      });
    }
    super.initState();
  }

  void onColorChanged(Color color) {
    setState(() {
      selectedWorkspaceColor = color;
    });
  }

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
    String headerToken = _tokenHeader.text.trim();

    if (name.isEmpty || url.isEmpty) {
      context.showCustomSnackBar('Please provide both name and URL');
      return;
    }

    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('workspaces');

    await collectionReference.add({
      'userRef': UserService().getUserReference(),
      'name': name,
      'url': url,
      'image': _imageUrl,
      'tokenHeader': headerToken,
      'workSpaceColor': "0x${selectedWorkspaceColor.toHexString()}"
    });

    Navigator.pop(context);
    context.showCustomSnackBar('Workspace added successfully');
  }

  void updateData() async {
    String name = _nameController.text.trim();
    String url = _urlController.text.trim();
    String tokenHeader = _tokenHeader.text.trim();

    if (name.isEmpty || url.isEmpty) {
      context.showCustomSnackBar('Please provide both name and URL');
      return;
    }

    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('workspaces');

    await collectionReference.doc(widget.workspaceId).update({
      'name': name,
      'url': url,
      'image': _imageUrl,
      'workSpaceColor': "0x${selectedWorkspaceColor.toHexString()}",
      'tokenHeader': tokenHeader,
    });

    Navigator.pop(context);
    context.showCustomSnackBar('Workspace updated successfully');
  }

  void deleteData() async {
    String confirmText = _confirmDeleteController.text.trim();

    if (confirmText != 'workspace') {
      context
          .showCustomSnackBar('Please type "Confirm" to delete the workspace');
      return;
    }

    String newPrimaryWorkspaceId = await showSelectWorkspaceDialog();

    if (newPrimaryWorkspaceId == null) {
      return;
    }

    await updatePrimaryWorkspace(newPrimaryWorkspaceId);
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('workspaces');

    await collectionReference.doc(widget.workspaceId).delete();

    Navigator.pop(context);
    Navigator.pushNamed(context, '/chatScreen');
  }

  Future<String> showSelectWorkspaceDialog() async {
    // Example implementation using a simple dialog
    String? selectedWorkspaceId = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        // Replace with your actual dialog implementation
        return AlertDialog(
          title: const Text("Select Primary Workspace"),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(null); // Cancel dialog
              },
            ),
            TextButton(
              child: const Text('Select'),
              onPressed: () {
                Navigator.of(context).pop(
                    'selected_workspace_id'); // Replace with actual selected workspace ID
              },
            ),
          ],
        );
      },
    );

    if (selectedWorkspaceId == null) {
      throw Exception('User canceled selecting new primary workspace');
    }

    return selectedWorkspaceId;
  }

  Future<void> updatePrimaryWorkspace(String newPrimaryWorkspaceId) async {
    // Assuming you have a 'users' collection where each document represents a user
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    await userDocRef.update({
      'primaryWorkSpace': newPrimaryWorkspaceId,
    });
  }

  Future<void> _uploadImageToFirebase(
      Uint8List fileBytes, String fileName) async {
    try {
      // Upload the image to Firebase Storage
      Reference storageReference =
          FirebaseStorage.instance.ref().child('images/$fileName');
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
      title: Text(
          (widget.workspaceId == null || widget.workspaceId!.isEmpty == true)
              ? 'Create Workspace'
              : 'Update Workspace'),
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
            TextFormField(
              controller: _tokenHeader,
              decoration: const InputDecoration(labelText: 'Header Token'),
            ),
            const SizedBox(height: 16),
            WorkspaceColor(
                onColorChanged: onColorChanged,
                defaultColor: selectedWorkspaceColor),
            _imageBytes != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Selected Image:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      _imageUrl != null
                          ? Image.network(_imageUrl!,
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover)
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
                      offset: const Offset(0, 1), // changes position of shadow
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
            const SizedBox(height: 16),
            if (!_showConfirmDeleteField &&
                !(widget.workspaceId == null ||
                    widget.workspaceId!.isEmpty == true))
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _showConfirmDeleteField = true;
                    });
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.delete_outlined,
                        color: Colors.black54,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Delete Workspace')
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            if (_showConfirmDeleteField)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                      'Confirm you want to delete this collection by typing its collection name: "workspace"'),
                  TextFormField(
                    controller: _confirmDeleteController,
                    decoration: const InputDecoration(
                      labelText: 'workspace',
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: deleteData,
                    child: Container(
                      height: 35,
                      alignment: Alignment.center,
                      width: 150,
                      decoration: BoxDecoration(
                        //0xFF39D2C0
                        color: Colors.red,
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
                        'Delete',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              )
            else
              Container(),
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
          onTap: (widget.workspaceId == null ||
                  widget.workspaceId!.isEmpty == true)
              ? addData
              : updateData,
          child: Container(
            height: 30,
            alignment: Alignment.center,
            width: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF39D2C0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ],
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            padding: const EdgeInsets.all(5),
            child: Text(
              _btnText!,
              style: const TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
