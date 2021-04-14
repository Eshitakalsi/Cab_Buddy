import 'package:cab_buddy/screens/user_details_list.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';

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
// scrollDirection: Axis.horizontal,
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
                                  return Container(
                                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    height: 220,
                                    width: double.maxFinite,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Card(
                                        elevation: 4,
                                        child: Container(
                                          child: Padding(
                                            padding: EdgeInsets.all(7),
                                            child: Stack(children: <Widget>[
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Stack(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10, top: 5),
                                                      child: Column(
                                                        children: <Widget>[
                                                          Row(
                                                            children: <Widget>[
                                                              infoIcon(userAds[
                                                                      index]
                                                                  .documentID),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              authorDetails(
                                                                  shot),
                                                              Spacer(),
                                                              timings(userAds[
                                                                  index]),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              carIcon(),
                                                              SizedBox(
                                                                width: 20,
                                                              )
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: <Widget>[
                                                              locationDetails(
                                                                  userAds[
                                                                      index]),
                                                              RaisedButton(
                                                                child: userAds[index]
                                                                            [
                                                                            'requestedUsers']
                                                                        .contains(LoggedInUserInfo
                                                                            .id)
                                                                    ? Text(
                                                                        'Cancel Request')
                                                                    : Text(
                                                                        'Request'),
                                                                color: Colors
                                                                        .yellow[
                                                                    300],
                                                                onPressed: () {
                                                                  sendOrDeleteRequest(
                                                                      userAds[
                                                                          index]);
                                                                },
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ]),
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              top: BorderSide(
                                                width: 2.0,
                                                color: Colors.yellow[100],
                                              ),
                                            ),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              });
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget infoIcon(id) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: IconButton(
          icon: Icon(
            Icons.info,
            color: Colors.yellow[300],
            size: 40,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => UserDetailsList(id, false)));
          },
        ),
      ),
    );
  }

  Widget authorDetails(ss) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          // text: '${data['userId']}',
          text: '${ss.data['firstName']}',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
          children: <TextSpan>[
            TextSpan(
                text: '\nYear: ${ss.data['year']}',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
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

  Widget timings(data) {
    return Align(
      alignment: Alignment.topRight,
      child: RichText(
        text: TextSpan(
          text: 'Pick Up',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.green, fontSize: 20),
          children: <TextSpan>[
            TextSpan(
                text: '\n${DateFormat.yMMMd().format(data['date'].toDate())}',
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
            TextSpan(
                text: '\n${DateFormat.jm().format(data['date'].toDate())}',
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget carIcon() {
    return Align(
        alignment: Alignment.topRight,
        child: Icon(
          Icons.time_to_leave,
          color: Colors.green,
          size: 30,
        ));
  }

  Widget locationDetails(data) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Row(
          children: <Widget>[
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: '\n${data['drop']}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '\n${data['pickup']}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
