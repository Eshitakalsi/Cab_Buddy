import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/loggedIn_user_info.dart';
import '../widgets/joined_card.dart';

class JoinedAdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          centerTitle: true,
          title: Text("Joined Ad"),
        ),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('Ads').snapshots(),
        builder: (ctx, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return Container();
          }
          final userAds = snapshots.data.documents;
          for (int index = 0; index < userAds.length; index++) {
            if (userAds[index]['joinedUsers'].contains(LoggedInUserInfo.id)) {
              return FutureBuilder(
                future: Firestore.instance
                    .collection('users')
                    .document(userAds[index].documentID)
                    .get(),
                builder: (ctx, shot) {
                  if (shot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }
                  return JoinedAd(
                    snapshot: userAds[index],
                    id: userAds[index].documentID,
                    name: shot.data['firstName'],
                    to: userAds[index]['drop'],
                    from: userAds[index]['pickup'],
                    time: userAds[index]['date'],
                    vacancies: userAds[index]['vacancy'],
                    imageUrl: shot.data['image_url'],
                    l: userAds[index]['joinedUsers'],
                  );
                },
              );
            }
          }
          return Container();
        },
      ),
    );
  }
}
