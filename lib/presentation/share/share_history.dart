import 'package:chatbot_text_tool/presentation/share/shared_chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/shared_history.dart';
import '../common/nothing_to_show.dart';

class ShareHistoryScreen extends StatefulWidget {
  final String workspaceColor;
  final String workSpaceId;

  const ShareHistoryScreen({super.key, required this.workspaceColor, required this.workSpaceId});

  @override
  State<ShareHistoryScreen> createState() => _ShareHistoryScreenState();
}

class _ShareHistoryScreenState extends State<ShareHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        centerTitle: true,
        backgroundColor: Color(int.parse(widget.workspaceColor)),
        title: const Text('Shared History'),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('shared_chats')
              .where("workspaceRef",isEqualTo: widget.workSpaceId)
              .orderBy("modifiedAt", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error fetching data'));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const NothingToShow();
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final sharedHistoryObj = snapshot.data!.docs[index];
                final sharedHistory = SharedHistory.fromFirestore(sharedHistoryObj);

                return _sharedHistoryItem(
                  sharedHistory: sharedHistory,
                  onToggleEnabled: () async{
                      FirebaseFirestore.instance
                          .collection('shared_chats')
                          .doc(snapshot.data!.docs[index].id)
                          .update({'status': !sharedHistory.enabled});
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

extension ReadableFormat on DateTime {
  String toReadableFormat() {
    return DateFormat('MM-dd-yyyy').format(this);
  }
}

class _sharedHistoryItem extends StatelessWidget {
  final SharedHistory sharedHistory;
  final VoidCallback onToggleEnabled;

  _sharedHistoryItem({
    required this.sharedHistory,
    required this.onToggleEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SharedChatScreen(fromDashboard: true,token: sharedHistory.id)),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(6),
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          const TextSpan(
                            text: 'Name: ',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          TextSpan(
                            text: sharedHistory.name,
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          const TextSpan(
                            text: 'Email: ',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          TextSpan(
                            text: sharedHistory.email,
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          const TextSpan(
                            text: 'Created Date: ',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          TextSpan(
                            text: sharedHistory.createdDate.toReadableFormat(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        sharedHistory.enabled
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                      ),
                      onPressed: onToggleEnabled,
                    ),
                    const Text(
                      'Enable',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
