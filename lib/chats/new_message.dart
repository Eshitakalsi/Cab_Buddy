import 'package:cab_buddy/models/loggedIn_user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NewMessage extends StatefulWidget {
  String id;
  NewMessage(this.id);
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = new TextEditingController();
  var _enteredMessage = '';

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    Firestore.instance
        .collection('Chats')
        .document(widget.id)
        .collection('Messages')
        .add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': LoggedInUserInfo.id,
      'username': LoggedInUserInfo.name,
      'userImage': LoggedInUserInfo.url,
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
              child: TextField(
            textCapitalization: TextCapitalization.sentences,
            autocorrect: false,
            enableSuggestions: false,
            controller: _controller,
            decoration: InputDecoration(labelText: 'Send a message...'),
            onChanged: (value) {
              setState(() {
                _enteredMessage = value;
              });
            },
          )),
          IconButton(
            icon: Icon(Icons.send),
            color: Theme.of(context).primaryColor,
            onPressed: _enteredMessage.trim().isEmpty
                ? null
                : () {
                    _sendMessage();
                  },
          )
        ],
      ),
    );
  }
}
