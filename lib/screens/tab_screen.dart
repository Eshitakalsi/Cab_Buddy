import 'package:cab_buddy/models/loggedIn_user_info.dart';
import 'package:cab_buddy/screens/favorite_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import '../widgets/app_drawer.dart';
import '../commons/theme.dart';
import './feed_screen.dart';
import './post_ad_screen.dart';
import './user_ads_screen.dart';

class TabScreen extends StatefulWidget {
  static const routeName = "/tabScreen";

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  @override
  void initState() {
    final fbm = FirebaseMessaging();
    fbm.subscribeToTopic(LoggedInUserInfo.id);
    fbm.requestNotificationPermissions();
    fbm.configure(onMessage: (msg) {
      showSimpleNotification(Text(msg['notification']['body']),
          background: Colors.black87);
    }, onLaunch: (msg) {
      print(msg);
    }, onResume: (msg) {
      print(msg);
    });
    super.initState();
  }

  List<Widget> _pages = [
    FeedScreen(),
    FavoriteScreen(),
    UserAdsScreen(),
  ];
  int _selectPageIndex = 0;
  void _selectPage(int index) {
    setState(() {
      _selectPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          centerTitle: true,
          title: Text(
            "Cab Buddy",
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, PostAdScreen.routeName);
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.yellowAccent,
        currentIndex: _selectPageIndex,
        onTap: _selectPage,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_outlined), label: 'Favorites'),
          BottomNavigationBarItem(
              icon: Icon(Icons.my_library_books), label: 'My Ads'),
        ],
      ),
    );
  }
}
