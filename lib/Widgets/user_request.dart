import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/loggedIn_user_info.dart';

class UserRequest extends StatelessWidget {
  final snapshot;
  UserRequest(this.snapshot);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                image: NetworkImage(snapshot.data['image_url']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            snapshot.data['firstName'],
            style: TextStyle(fontSize: 20),
          ),
          subtitle: Row(
            children: [
              Text('Year: ${snapshot.data['year']}'),
              SizedBox(
                width: 20,
              ),
              Text('Batch: ${snapshot.data['batch']}'),
            ],
          ),
          trailing: Container(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    denyRequest(snapshot.data.documentID);
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    acceptRequest(snapshot.data.documentID);
                  },
                ),
              ],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }

  Future<void> acceptRequest(id) async {
    try {
      var doc = await Firestore.instance
          .collection('Ads')
          .document(LoggedInUserInfo.id)
          .get();

      List requested = doc['requestedUsers'];
      requested.remove(id);
      List joined = doc['joinedUsers'];
      joined.add(id);
      String vacancies = doc['vacancy'];
      var v = int.parse(vacancies);
      v = v - 1;
      print(v);
      if (v == 0) {
        for (var i = 0; i < requested.length; i++) {
          await Firestore.instance
              .collection('userRequestedAds')
              .document(requested[i])
              .delete();
        }
        requested = [];
      }
      await Firestore.instance
          .collection('userRequestedAds')
          .document(id)
          .delete();
      await Firestore.instance
          .collection('userJoinedAds')
          .document(id)
          .setData({"adId": LoggedInUserInfo.id});

      await Firestore.instance
          .collection('Ads')
          .document(LoggedInUserInfo.id)
          .updateData({
        'requestedUsers': requested,
        'joinedUsers': joined,
        'vacancy': v.toString()
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> denyRequest(id) async {
    try {
      var doc = await Firestore.instance
          .collection('Ads')
          .document(LoggedInUserInfo.id)
          .get();

      List l = doc['requestedUsers'];
      l.remove(id);
      await Firestore.instance
          .collection('userRequestedAds')
          .document(id)
          .delete();
      await Firestore.instance
          .collection('Ads')
          .document(LoggedInUserInfo.id)
          .updateData({'requestedUsers': l});

      return;
    } catch (error) {
      print("...");
    }
  }
}
