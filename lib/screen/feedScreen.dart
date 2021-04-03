import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/feed_data.dart';

class FeedScreen extends StatelessWidget {
  static const routeName = "/FeedScreen";
  var feedData = FeedData.getData;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(30.0),
              child: AppBar(
                elevation: 0,
                brightness: Brightness.light,
                backgroundColor: Colors.white,
              ),
            ),
            body: StreamBuilder(
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
                                                        infoIcon(),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        authorDetails(
                                                            userAds[index]),
                                                        Spacer(),
                                                        timings(userAds[index]),
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
                                                        RaisedButton(
                                                          child: Text('Join'),
                                                          color: Colors
                                                              .yellow[300],
                                                          onPressed: () {},
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
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                })));
  }

  Widget infoIcon() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.info,
            color: Colors.yellow[300],
            size: 40,
          )),
    );
  }

  Widget authorDetails(data) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          // text: '${data['userId']}',
          text: '${data['userName']}',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
          children: <TextSpan>[
            TextSpan(
                text: '\nYear: ${data['userYear']}',
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
