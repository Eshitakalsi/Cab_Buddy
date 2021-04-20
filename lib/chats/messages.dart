import 'package:cab_buddy/models/loggedIn_user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

// ignore: must_be_immutable
class Messages extends StatelessWidget {
  final id;
  Messages(this.id);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('Chats')
            .document(id)
            .collection('Messages')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final chatDocs = chatSnapshot.data.documents;
          return ListView.builder(
            reverse: true,
            itemCount: chatDocs.length,
            itemBuilder: (ctx, index) => MessageBubble(
                chatDocs[index]['username'],
                chatDocs[index]['text'],
                chatDocs[index]['userImage'],
                chatDocs[index]['userId'] == LoggedInUserInfo.id,
                ValueKey(chatDocs[index].documentID)),
          );
        });
  }
}
