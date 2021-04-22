import 'package:cab_buddy/widgets/favorite_card.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/loggedIn_user_info.dart';
import '../widgets/feed_card.dart';

class FavoriteScreen extends StatefulWidget {
  static const routeName = "/feedScreen";

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('Ads').snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 0,
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
                        : StreamBuilder(
                            stream: Firestore.instance
                                .collection('users')
                                .document(userAds[index].documentID)
                                .snapshots(),
                            builder: (context, shot) {
                              if (shot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container();
                              } else {
                                return FavoriteCard(
                                  snapshot: userAds[index],
                                  joinedUserId: shot.data.documentID,
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
}
