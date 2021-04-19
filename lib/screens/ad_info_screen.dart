import 'package:cab_buddy/Widgets/user_details.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/loggedIn_user_info.dart';

class AdInfoScreen extends StatefulWidget {
  final ss;
  final isDeleteAllowed;

  AdInfoScreen(
    this.ss,
    this.isDeleteAllowed,
  );

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
            FlatButton(
              onPressed: () {
                sendOrDeleteRequest();
              },
              child: widget.ss['requestedUsers'].contains(LoggedInUserInfo.id)
                  ? Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    )
                  : Text(
                      'Join',
                      style: TextStyle(color: Colors.white),
                    ),
            )
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
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
                  return UserDetails(snapshot, widget.isDeleteAllowed);
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
      return;
    }
    final doc1 = await Firestore.instance
        .collection('userJoinedAds')
        .document(LoggedInUserInfo.id)
        .get();
    if (doc1.exists) {
      return;
    }
    final doc2 = await Firestore.instance
        .collection('userRequestedAds')
        .document(LoggedInUserInfo.id)
        .get();
    if (doc2.exists) {
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
