import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/loggedIn_user_info.dart';
import '../widgets/feed_card.dart';

class FeedScreen extends StatefulWidget {
  static const routeName = "/feedScreen";

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  String searchString;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 30,
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                  ),
                  onChanged: (value) {
                    setState(
                      () {
                        searchString = value.toLowerCase();
                      },
                    );
                  },
                ),
              ),
              IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.black87,
                  ),
                  onPressed: () {}),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder(
            stream: (searchString == null || searchString.trim() == "")
                ? Firestore.instance.collection('Ads').snapshots()
                : Firestore.instance
                    .collection('Ads')
                    .where("searchIndex",
                        arrayContains: searchString.toLowerCase())
                    .snapshots(),
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
                          return userAds[index].documentID ==
                                      LoggedInUserInfo.id ||
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
          ),
        ),
      ],
    );
  }
}
