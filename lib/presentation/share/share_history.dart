import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShareHistoryScreen extends StatefulWidget {
  final String workspaceColor;
  ShareHistoryScreen({super.key, required this.workspaceColor});

  @override
  State<ShareHistoryScreen> createState() => _ShareHistoryScreenState();
}

class _ShareHistoryScreenState extends State<ShareHistoryScreen> {
  final List<SharedHistory> _sharedHistories = [
    SharedHistory(name: 'John Doe', email: 'john@example.com', createdDate: DateTime.now(), enabled: true),
    SharedHistory(name: 'Jane Smith', email: 'jane@example.com', createdDate: DateTime.now(), enabled: false),
    // Add more items as needed
  ];

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
        margin: EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemCount: _sharedHistories.length,
          itemBuilder: (context, index) {
            return SharedHistoryItem(
              sharedHistory: _sharedHistories[index],
              onToggleEnabled: () {
                setState(() {
                  _sharedHistories[index].enabled = !_sharedHistories[index].enabled;
                });
              },
            );
          },
        ),
      ),
    );
  }
}

class SharedHistory {
  final String name;
  final String email;
  final DateTime createdDate;
  bool enabled;

  SharedHistory({
    required this.name,
    required this.email,
    required this.createdDate,
    this.enabled = false,
  });
}

extension ReadableFormat on DateTime {
  String toReadableFormat() {
    return DateFormat('MM-dd-yyyy').format(this);
  }
}

class SharedHistoryItem extends StatelessWidget {
  final SharedHistory sharedHistory;
  final VoidCallback onToggleEnabled;
  DateTime dateTime = DateTime.parse("2024-07-11T18:17:23.603");

  SharedHistoryItem({
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
      child: Container(
        padding: EdgeInsets.all(6),
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
                        TextSpan(
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
                        TextSpan(
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
                        TextSpan(
                          text: 'Created Date: ',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        TextSpan(
                          text:dateTime.toReadableFormat(),
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
                      sharedHistory.enabled ? Icons.check_box : Icons.check_box_outline_blank,
                    ),
                    onPressed: onToggleEnabled,
                  ),
                  Text('Enable',style: TextStyle(fontSize: 15),),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
