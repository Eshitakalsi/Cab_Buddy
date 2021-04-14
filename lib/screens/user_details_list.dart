import 'package:cab_buddy/Widgets/user_details.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetailsList extends StatelessWidget {
  final id;
  final isDeleteAllowed;
  UserDetailsList(this.id, this.isDeleteAllowed);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          title: Text("UserDetails"),
        ),
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection('Ads').document(id).snapshots(),
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
                    return UserDetails(snapshot, isDeleteAllowed);
                  },
                );
              },
            );
          }),
    );
  }
}
