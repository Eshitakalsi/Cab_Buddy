import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/loggedIn_user_info.dart';

class InfoCard extends StatelessWidget {
  final snapshot;
  final isDeletable;

  InfoCard({
    this.snapshot,
    this.isDeletable,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 118,
      child: Card(
        key: ValueKey(snapshot.data['firstName']),
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black87,
          ),
          child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right:
                          new BorderSide(width: 1.0, color: Colors.white24))),
              child: Hero(
                tag: "avatar_" + snapshot.data['firstName'],
                child: CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage(
                    snapshot.data['image_url'],
                  ),
                ),
              ),
            ),
            title: Text(
              snapshot.data['firstName'],
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            subtitle: Row(
              children: <Widget>[
                new Flexible(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          text: 'Year: ${snapshot.data['year']}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        maxLines: 3,
                        softWrap: true,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Batch: ${snapshot.data['batch']}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        maxLines: 3,
                        softWrap: true,
                      ),
                    ],
                  ),
                )
              ],
            ),
            trailing: isDeletable
                ? IconButton(
                    icon: Icon(
                      Icons.delete,
                    ),
                    color: Colors.red[300],
                    iconSize: 30,
                    onPressed: () {
                      kickUser(context, snapshot.data.documentID);
                    },
                  )
                : Container(
                    width: 0,
                    height: 0,
                  ),
            onTap: () {},
          ),
        ),
      ),
    );
  }

  Future<void> removeUser(id) async {
    try {
      var doc = await Firestore.instance
          .collection('Ads')
          .document(LoggedInUserInfo.id)
          .get();

      List l = doc['joinedUsers'];
      l.remove(id);
      await Firestore.instance
          .collection('userJoinedAds')
          .document(id)
          .delete();
      await Firestore.instance
          .collection('Ads')
          .document(LoggedInUserInfo.id)
          .updateData({
        'joinedUsers': l,
        'vacancy': (int.parse(doc['vacancy']) + 1).toString()
      });

      return;
    } catch (error) {
      print("...");
    }
  }

  kickUser(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, sets) {
          return AlertDialog(
            title: Text('Are you sure?'),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  "Confirm",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  removeUser(id);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }
}
