import 'package:cab_buddy/models/loggedIn_user_info.dart';
import 'package:cab_buddy/screens/user_details_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JoinedAdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          title: Text("Joined Ad"),
        ),
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection('Ads').snapshots(),
          builder: (ctx, snapshots) {
            if (snapshots.connectionState == ConnectionState.waiting) {
              return Container();
            }
            final docs = snapshots.data.documents;
            for (int i = 0; i < docs.length; i++) {
              if (docs[i]['joinedUsers'].contains(LoggedInUserInfo.id)) {
                return FutureBuilder(
                  future: Firestore.instance
                      .collection('users')
                      .document(docs[i].documentID)
                      .get(),
                  builder: (ctx, ss) {
                    if (ss.connectionState == ConnectionState.waiting) {
                      return Container();
                    }
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
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 5),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              infoIcon(
                                                  docs[i].documentID, context),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              authorDetails(ss),
                                              Spacer(),
                                              timings(docs[i]),
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
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              locationDetails(docs[i]),
                                              ElevatedButton(
                                                  child: Text("Leave room"),
                                                  onPressed: () {
                                                    leaveRoom(docs[i]);
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
                  },
                );
              }
            }
            return Container();
          }),
    );
  }

  Widget infoIcon(id, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => UserDetailsList(id, false)));
              },
              icon: Icon(
                Icons.info,
                color: Colors.yellow[300],
                size: 40,
              ))),
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

  Future<void> leaveRoom(data) async {
    try {
      List l = data['joinedUsers'];
      l.remove(LoggedInUserInfo.id);
      String vacancies = data['vacancy'];
      var v = int.parse(vacancies);
      v = v + 1;
      await Firestore.instance
          .collection('Ads')
          .document(data.documentID)
          .updateData({
        'joinedUsers': l,
        'vacancy': v.toString(),
      });
      Firestore.instance
          .collection('userJoinedAds')
          .document(LoggedInUserInfo.id)
          .delete();
    } catch (err) {
      print(err);
    }
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
