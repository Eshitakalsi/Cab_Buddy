import 'package:flutter/material.dart';

import 'new_message.dart';
import 'Messages.dart';

class ChatScreen extends StatelessWidget {
  final id;
  ChatScreen(this.id);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat Screen')),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(child: Messages(id)),
            NewMessage(id),
          ],
        ),
      ),
    );
  }
}
