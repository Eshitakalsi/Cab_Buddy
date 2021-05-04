import 'package:cab_buddy/models/loggedIn_user_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import 'new_message.dart';
import 'Messages.dart';

class ChatScreen extends StatefulWidget {
  final id;
  ChatScreen(this.id);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    final fbm = FirebaseMessaging();
    fbm.subscribeToTopic(LoggedInUserInfo.id);
    fbm.requestNotificationPermissions();
    fbm.configure(onMessage: (msg) {
      showSimpleNotification(Text(msg['notification']['body']),
          background: Colors.black87);
    }, onLaunch: (msg) {
      print(msg);
    }, onResume: (msg) {
      print(msg);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Chat'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(child: Messages(widget.id)),
            NewMessage(widget.id),
          ],
        ),
      ),
    );
  }
}
