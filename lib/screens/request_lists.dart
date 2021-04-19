import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/user_request.dart';
import '../models/loggedIn_user_info.dart';

class RequestLists extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          title: Text("Requests"),
        ),
      ),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('Ads')
              .document(LoggedInUserInfo.id)
              .snapshots(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }
            return ListView.builder(
              itemCount: snapshot.data['requestedUsers'].length,
              itemBuilder: (ctx, idx) {
                return FutureBuilder(
                  future: Firestore.instance
                      .collection('users')
                      .document(snapshot.data['requestedUsers'][idx])
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    }
                    return UserRequest(snapshot);
                  },
                );
              },
            );
          }),
    );
  }
}
