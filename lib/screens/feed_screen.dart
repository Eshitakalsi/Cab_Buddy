import 'package:cab_buddy/widgets/feed_card.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/loggedIn_user_info.dart';

class FeedScreen extends StatefulWidget {
  static const routeName = "/feedScreen";

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('Ads').snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: MediaQuery.of(context).size.height / 7,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/car.gif'),
              ),
            ),
          );
        }
        final userAds = snapshot.data.documents;
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: userAds.length,
                  itemBuilder: (context, index) {
                    return userAds[index].documentID == LoggedInUserInfo.id ||
                            userAds[index]['joinedUsers']
                                .contains(LoggedInUserInfo.id) ||
                            userAds[index]['vacancy'] == "0"
                        ? Container(
                            height: 0,
                          )
                        : FutureBuilder(
                            future: Firestore.instance
                                .collection('users')
                                .document(userAds[index].documentID)
                                .get(),
                            builder: (context, shot) {
                              if (shot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container();
                              } else {
                                return FeedCard(
                                  name: shot.data['firstName'],
                                  to: userAds[index]['drop'],
                                  from: userAds[index]['pickup'],
                                  time: userAds[index]['date'],
                                  vacancies: userAds[index]['vacancy'],
                                  year: shot.data['year'],
                                  imageUrl: shot.data['image_url'],
                                );
                              }
                            },
                          );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> sendOrDeleteRequest(data) async {
    String id = data.documentID;
    List l = data['requestedUsers'];
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
  }
}
