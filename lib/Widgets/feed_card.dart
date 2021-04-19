import 'package:cab_buddy/commons/theme.dart';
import 'package:cab_buddy/screens/ad_info_screen.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import './separator.dart';

class FeedCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => AdInfoScreen(
              snapshot,
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
                        SizedBox(
                          width: 14,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 22,
                          ),
                          child: Text(
                            'Year: $year',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
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
    );
  }
}
