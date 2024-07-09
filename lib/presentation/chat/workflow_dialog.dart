import 'dart:typed_data';
import 'package:chatbot_text_tool/presentation/chat/chat_screen.dart';
import 'package:chatbot_text_tool/presentation/common/color_picker.dart';
import 'package:chatbot_text_tool/service/user_service.dart';
import 'package:chatbot_text_tool/utils/custom_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../service/shared_pref_service.dart';
import '../common/key_value_list.dart';

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
  final TextEditingController _authHeaderKeyController = TextEditingController();
  final TextEditingController _confirmDeleteController = TextEditingController();

  var headerKeyValues = [
    const MapEntry('key1', 'value1'),
  ];

  // Selected token type
  String? selectedToken;

  final authTokenTypes = [
    "Bearer",
    "Basic",
    "Digest",
    "OAuth",
    "JWT",
    "API Key",
    "Hawk",
    "AWS4-HMAC-SHA256",
    "NTLM",
    "Negotiate",
    "Token",
    "SAML",
    "Access Token",
    "Client-ID",
    "Session ID"
  ];

  Color selectedWorkspaceColor = Colors.grey.withAlpha(100);
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
    String authHeaderKey = _authHeaderKeyController.text.trim();

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

  void deleteWorkspace() async {
    String confirmText = _confirmDeleteController.text.trim();

    if (confirmText != 'workspace') {
      context
          .showCustomSnackBar('Please type "Confirm" to delete the workspace');
      return;
    }

    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('workspaces');

    await collectionReference.doc(widget.workspaceId).delete();
    await showSelectWorkspaceDialog();
  }

  Future<String> showSelectWorkspaceDialog() async {
    String? selectedWorkspaceId = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {

        return AlertDialog(
          title: const Text("Select Primary Workspace"),
          content: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('workspaces').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final filteredDocs = snapshot.data!.docs.where((doc) {
                return doc["userRef"] == UserService().getUserReference();
              }).toList();

              return SizedBox(
                width: double.minPositive,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredDocs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(filteredDocs[index]['name']),
                      onTap: () async {
                        final doc = filteredDocs[index];
                        final workspaceId = doc.id;
                        final workspaceRef = FirebaseFirestore.instance
                            .collection('workspaces')
                            .doc(workspaceId);
                        final userRef = UserService().getUserReference();
                        try {
                          await userRef.update({
                            'primaryWorkSpace': workspaceRef,
                          });
                          await SessionManager.updateUserWorkSpace(
                              workSpaceReferance: workspaceRef.id);

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const ChatScreen()),
                          );
                        } catch (e) {
                          print("Error updating workspace: $e");
                        }
                      });
                  },
                ),
              );
            },
          ),
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
      contentPadding: const EdgeInsets.all(20.0),
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        const SizedBox(height: 25),
                        WorkspaceColor(
                            onColorChanged: onColorChanged,
                            defaultColor: selectedWorkspaceColor),
                      ],
                    ),
                  ),
                  const SizedBox(width: 50,),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 150,
                      width: 150,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(75),
                        border: Border.all(color: Colors.grey.withAlpha(100))
                      ),
                      child: _imageUrl != null
                          ? Image.network(_imageUrl!,
                          height: double.infinity,
                          width: double.infinity,
                          fit: BoxFit.cover) : const Icon(
                        Icons.star,
                        size: 80,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(50),
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.security),
                        SizedBox(width: 5,),
                        Text(
                          "Authorization",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          child: TextFormField(
                            controller: _authHeaderKeyController,
                            decoration: const InputDecoration(
                              hintText: 'Key',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 150,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              hintText: 'Token Type',
                              contentPadding: EdgeInsets.symmetric(vertical: 0),
                              border: UnderlineInputBorder(),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedToken,
                                isExpanded: true,
                                hint: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text('Token Type',
                                      overflow: TextOverflow.ellipsis),
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedToken = newValue;
                                  });
                                },
                                items: authTokenTypes
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Text(value,
                                            overflow: TextOverflow.ellipsis)),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _tokenHeader,
                            decoration: const InputDecoration(
                                hintText: 'Header Token'
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Header Values",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10,),
                  KeyValueList(
                    initialPairs: headerKeyValues,
                    onChanged: (pairs) {
                      setState(() {
                        headerKeyValues = pairs;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_showConfirmDeleteField)
                Container(
                  decoration: BoxDecoration(
                    color : Colors.redAccent.withAlpha(50),
                    borderRadius: BorderRadius.circular(15)
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.delete,color: Colors.black87),
                              SizedBox(width: 5,),
                              Text(
                                "Delete Workspace",
                                style: TextStyle(fontSize: 16,color: Colors.black87),
                              ),
                            ],
                          ),

                          GestureDetector(
                              onTap: (){
                                setState(() {
                                  _showConfirmDeleteField = false;
                                });
                              },
                              child: const Icon(Icons.close,color: Colors.black87)
                          )
                        ],
                      ),
                      const SizedBox(height: 15,),
                      const Text(
                        'Confirm you want to delete this collection by typing its collection name: "Name of your workspace"',
                        style: TextStyle(color: Colors.black54),
                      ),
                      TextFormField(
                        controller: _confirmDeleteController,
                        style: const TextStyle(
                          fontSize: 14
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Type name of Workspace',
                          hintStyle: TextStyle(
                              fontSize: 14,
                            color: Colors.black54
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: deleteWorkspace,
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
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
      actions: [
        if (!_showConfirmDeleteField && !(widget.workspaceId == null || widget.workspaceId!.isEmpty == true))
          InkWell(
            onTap: () {
              setState(() {
                _showConfirmDeleteField = true;
              });
            },
            child: Container(
              width: 155,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.grey.withAlpha(10))
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.delete_outlined,
                    color: Colors.redAccent.withAlpha(180),
                    size: 22,
                  ),
                  Text(
                    'Delete Workspace',
                    style: TextStyle(
                      color: Colors.redAccent.withAlpha(180),
                    ),
                  )
                ],
              ),
            ),
          ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel', style: TextStyle(
            color: Colors.black87
          ),),
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
