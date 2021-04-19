import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';

import './separator.dart';
import '../screens/request_lists.dart';
import '../commons/theme.dart';
import '../screens/ad_info_screen.dart';

class MyAd extends StatelessWidget {
  final snapshot;
  final imageUrl;
  final id;
  final name;
  final to;
  final from;
  final time;
  final vacancies;
  final requestList;
  final joinedList;

  MyAd({
    this.snapshot,
    this.id,
    this.imageUrl,
    this.name,
    this.to,
    this.from,
    this.time,
    this.vacancies,
    this.requestList,
    this.joinedList,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      onDismissed: (direction) {
        deleteAd();
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('Are You Sure?'),
                content: Text("Do you want to remove the item from the cart?"),
                actions: <Widget>[
                  FlatButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      }),
                  FlatButton(
                      child: Text('Yes'),
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      }),
                ],
              );
            });
      },
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red[400],
        child: Icon(Icons.delete, color: Colors.white, size: 40),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => AdInfoScreen(
                snapshot,
                true,
                false,
              ),
            ),
          );
        },
        child: Container(
          height: 150,
          margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Stack(
            children: [
              Container(
                child: Container(
                  constraints: BoxConstraints.expand(),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              left: 80,
                              top: 20,
                            ),
                            child: Text(
                              name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 27,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 6, right: 5),
                            child: IconButton(
                              icon: Icon(Icons.pending),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => RequestLists(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              left: 80,
                              top: 8,
                            ),
                            child: Text(
                              'To: $to',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: 20,
                              top: 8,
                            ),
                            child: Text(
                              'From: $from',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Separator(),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              left: 80,
                              top: 8,
                            ),
                            child: Text(
                              'Left: $vacancies',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: 20,
                              top: 8,
                            ),
                            child: Text(
                              'Time: ${DateFormat.MMMMd().add_jm().format(time.toDate())}',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  height: 124,
                  margin: EdgeInsets.only(left: 46),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.rectangle,
                    borderRadius: new BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 16,
                ),
                alignment: FractionalOffset.centerLeft,
                child: Container(
                  width: 95,
                  height: 95,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deleteAd() async {
    try {
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
      await Firestore.instance.collection('Ads').document(id).delete();
    } catch (err) {
      print(err);
    }
  }
}
