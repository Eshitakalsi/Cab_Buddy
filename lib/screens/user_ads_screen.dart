import 'package:cab_buddy/screens/user_details_list.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/loggedIn_user_info.dart';
import './request_lists.dart';

class UserAdsScreen extends StatefulWidget {
  static const routeName = "/feedScreen";

  @override
  _UserAdsScreenState createState() => _UserAdsScreenState();
}

class _UserAdsScreenState extends State<UserAdsScreen> {
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
                      return userAds[index].documentID != LoggedInUserInfo.id
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
                                    child: Card(
                                      elevation: 5,
                                      child: Container(
                                        child: Padding(
                                          padding: EdgeInsets.all(7),
                                          child: Stack(children: <Widget>[
                                            Align(
                                              alignment: Alignment.centerRight,
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
                                                            Column(
                                                              children: [
                                                                infoIcon(
                                                                    userAds[
                                                                        index]),
                                                                IconButton(
                                                                    icon: Icon(
                                                                      Icons
                                                                          .info_outline_rounded,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(context).push(MaterialPageRoute(
                                                                          builder: (ctx) => UserDetailsList(
                                                                              LoggedInUserInfo.id,
                                                                              true)));
                                                                    })
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            authorDetails(shot),
                                                            Spacer(),
                                                            timings(
                                                                userAds[index]),
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
                                                                userAds[index]),
                                                            IconButton(
                                                                color:
                                                                    Colors.red,
                                                                iconSize: 30,
                                                                icon: Icon(Icons
                                                                    .delete),
                                                                onPressed: () {
                                                                  deleteAd(
                                                                      userAds[
                                                                          index]);
                                                                })
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

  Widget infoIcon(data) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (ctx) => RequestLists()));
              },
              icon: Icon(
                Icons.info,
                color: Colors.yellow[300],
                size: 40,
              ))),
    );
  }

  Future<void> deleteAd(data) async {
    try {
      List requestList = data['requestedUsers'];
      List joinedList = data['joinedUsers'];
      for (int i = 0; i < requestList.length; i++) {
        await Firestore.instance
            .collection('userRequestedAds')
            .document(requestList[i])
            .delete();
      }
      for (int i = 0; i < joinedList.length; i++) {
        await Firestore.instance
            .collection('userJoinedAds')
            .document(joinedList[i])
            .delete();
      }
      await Firestore.instance
          .collection('Ads')
          .document(data.documentID)
          .delete();
    } catch (err) {
      print(err);
    }
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