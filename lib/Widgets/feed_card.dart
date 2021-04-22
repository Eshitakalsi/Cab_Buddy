import 'package:cab_buddy/models/loggedIn_user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import './separator.dart';
import '../commons/theme.dart';
import '../screens/ad_info_screen.dart';

class FeedCard extends StatefulWidget {
  final snapshot;
  final joinedUserId;
  final imageUrl;
  final name;
  final to;
  final from;
  final time;
  final vacancies;
  final year;
  FeedCard({
    this.snapshot,
    this.joinedUserId,
    this.imageUrl,
    this.name,
    this.to,
    this.from,
    this.time,
    this.vacancies,
    this.year,
  });

  @override
  _FeedCardState createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => AdInfoScreen(
              widget.snapshot,
              false,
              true,
            ),
          ),
        );
      },
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(LoggedInUserInfo.id)
            .snapshots(),
        builder: (context, ss) {
          if (ss.connectionState == ConnectionState.waiting) {
            return Container(
              height: 150,
            );
          }
          return Container(
            height: 175,
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
            child: Stack(
              children: [
                Container(
                  child: Container(
                    constraints: BoxConstraints.expand(),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                left: 80,
                                top: 20,
                              ),
                              child: Text(
                                widget.name,
                                style: TextStyle(
                                  fontSize: 27,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            SizedBox(
                              width: 14,
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: 22,
                              ),
                              child: Text(
                                'Year: ${widget.year}',
                                style: TextStyle(
                                  fontFamily: 'Josefin Sans',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                left: 35,
                                top: 15,
                              ),
                              child: IconButton(
                                icon: Icon(ss.data['favorites']
                                        .contains(widget.snapshot.documentID)
                                    ? Icons.favorite
                                    : Icons.favorite_border),
                                onPressed: () {
                                  toggleFavorite(ss);
                                },
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                left: 80,
                                top: 15,
                              ),
                              child: Text(
                                'To: ${widget.to}',
                                style: TextStyle(
                                  fontFamily: 'Josefin Sans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                left: 20,
                                top: 15,
                              ),
                              child: Text(
                                'From: ${widget.from}',
                                style: TextStyle(
                                  fontFamily: 'Josefin Sans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
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
                                'Left: ${widget.vacancies}',
                                style: TextStyle(
                                  fontFamily: 'Josefin Sans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
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
                                'Time: ${DateFormat.MMMMd().add_jm().format(widget.time.toDate())}',
                                style: TextStyle(
                                  fontFamily: 'Josefin Sans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
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
                    vertical: 12,
                  ),
                  alignment: FractionalOffset.centerLeft,
                  child: Container(
                    width: 95,
                    height: 95,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        image: NetworkImage(widget.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void toggleFavorite(final ss) async {
    try {
      List fav = ss.data['favorites'];
      if (fav.contains(widget.snapshot.documentID)) {
        fav.remove(widget.snapshot.documentID);
      } else {
        fav.add(widget.snapshot.documentID);
      }
      await Firestore.instance
          .collection('users')
          .document(LoggedInUserInfo.id)
          .updateData({'favorites': fav});
    } catch (Error) {}
  }
}
