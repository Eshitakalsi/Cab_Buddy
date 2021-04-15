import 'package:cab_buddy/commons/theme.dart';
import 'package:flutter/material.dart';

import './separator.dart';

class FeedCard extends StatelessWidget {
  final planetThumbnail = Container(
    margin: EdgeInsets.symmetric(
      vertical: 16,
    ),
    alignment: FractionalOffset.centerLeft,
    child: Image.network(
      'https://i.pinimg.com/474x/84/46/7f/84467f0fb904f147559e58b55aa8df64.jpg',
      height: 92,
      width: 92,
    ),
  );

  final planetCard = Container(
    child: Container(
      constraints: BoxConstraints.expand(),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(
              left: 80,
              top: 20,
            ),
            child: Text(
              'Eshita',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 27,
                color: Colors.white,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: 80,
                  top: 8,
                ),
                child: Text(
                  'To: 128',
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
                  'From: 62',
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
            height: 2,
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
                  'Left: 2',
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
                  'Time: 2 PM',
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
  );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 150,
        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Stack(
          children: [
            planetCard,
            planetThumbnail,
          ],
        ),
      ),
    );
  }
}
