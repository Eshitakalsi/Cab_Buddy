import 'package:cab_buddy/chats/chat_screen.dart';
import 'package:cab_buddy/widgets/info_card.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/loggedIn_user_info.dart';

class AdInfoScreen extends StatefulWidget {
  var ss;
  final isDeleteAllowed;
  final isJoinable;
  AdInfoScreen(this.ss, this.isDeleteAllowed, this.isJoinable);

  @override
  _AdInfoScreenState createState() => _AdInfoScreenState();
}

class _AdInfoScreenState extends State<AdInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          title: Text("Information"),
          actions: [
            widget.isJoinable
                ? FlatButton(
                    onPressed: () {
                      sendOrDeleteRequest();
                    },
                    child: widget.ss['requestedUsers']
                            .contains(LoggedInUserInfo.id)
                        ? Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white),
                          )
                        : Text(
                            'Join',
                            style: TextStyle(color: Colors.white),
                          ),
                  )
                : IconButton(
                    icon: Icon(Icons.chat),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => ChatScreen(widget.ss.documentID)));
                    })
            // IconButton(
            //   icon: Icon(
            //     Icons.add,
            //     color: Colors.white,
            //   ),
            //   onPressed: () {
            //     sendOrDeleteRequest();
            //   },
            // ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('Ads')
            .document(widget.ss.documentID)
            .snapshots(),
        builder: (ctx, snapshot) {
          widget.ss = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          print(snapshot.data['joinedUsers'].length);

          return ListView.builder(
            itemCount: snapshot.data['joinedUsers'].length,
            itemBuilder: (ctx, idx) {
              return FutureBuilder(
                future: Firestore.instance
                    .collection('users')
                    .document(snapshot.data['joinedUsers'][idx])
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }
                  return InfoCard(
                    snapshot: snapshot,
                    isDeletable: widget.isDeleteAllowed,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> sendOrDeleteRequest() async {
    String id = widget.ss.documentID;
    List l = widget.ss['requestedUsers'];
    if (l.contains(LoggedInUserInfo.id)) {
      l.remove(LoggedInUserInfo.id);
      await Firestore.instance
          .collection('userRequestedAds')
          .document(LoggedInUserInfo.id)
          .delete();
      await Firestore.instance
          .collection('Ads')
          .document(id)
          .updateData({'requestedUsers': l});
      setState(() {});

      return;
    }
    final doc1 = await Firestore.instance
        .collection('userJoinedAds')
        .document(LoggedInUserInfo.id)
        .get();
    if (doc1.exists) {
      setState(() {});

      return;
    }
    final doc2 = await Firestore.instance
        .collection('userRequestedAds')
        .document(LoggedInUserInfo.id)
        .get();
    if (doc2.exists) {
      setState(() {});

      return;
    }
    l.add(LoggedInUserInfo.id);
    await Firestore.instance
        .collection('Ads')
        .document(id)
        .updateData({'requestedUsers': l});

    await Firestore.instance
        .collection('userRequestedAds')
        .document(LoggedInUserInfo.id)
        .setData({"adId": id});

    setState(() {});
  }
}
