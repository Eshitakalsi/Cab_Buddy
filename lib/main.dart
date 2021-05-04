import 'package:cab_buddy/screens/user_ads_screen.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:overlay_support/overlay_support.dart';

import './screens/error_screen.dart';
import './screens/feed_screen.dart';
import './screens/post_ad_screen.dart';
import './screens/signin_screen.dart';
import './screens/splash_screen.dart';
import './screens/tab_screen.dart';
import './screens/user_form_screen.dart';
import './commons/theme.dart';
import './models/loggedIn_user_info.dart';
import './screens/profile_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Home Page',
          theme: ThemeData(
            fontFamily: 'Montserrat',
            primarySwatch: primarySwatch,
            primaryColor: primaryColor,
            accentColor: accentColor,
            errorColor: Colors.red,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.onAuthStateChanged,
            builder: (ctx, AsyncSnapshot<FirebaseUser> userSnapshot) {
              print("Change");
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return SplashScreen();
              }
              if (userSnapshot.hasData) {
                return FutureBuilder(
                  future: Firestore.instance
                      .collection('users')
                      .document(userSnapshot.data.uid)
                      .get(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> ss) {
                    if (ss.connectionState == ConnectionState.waiting) {
                      return SplashScreen();
                    } else if (ss.hasError) {
                      return ErrorScreen();
                    } else {
                      if (ss.data.data != null) {
                        LoggedInUserInfo.id = userSnapshot.data.uid;
                        LoggedInUserInfo.name = ss.data.data['firstName'] +
                            " " +
                            ss.data.data['lastName'];
                        LoggedInUserInfo.year = ss.data.data['year'];
                        LoggedInUserInfo.gender = ss.data.data['gender'];
                        LoggedInUserInfo.sector = ss.data.data['sector'];
                        LoggedInUserInfo.batch = ss.data.data['batch'];
                        LoggedInUserInfo.url = ss.data.data['image_url'];
                        LoggedInUserInfo.email = userSnapshot.data.email;
                        LoggedInUserInfo.favorites = ss.data['favorites'];
                        return TabScreen();
                      } else {
                        return UserFormScreen(
                            userSnapshot.data.uid, userSnapshot.data.email);
                      }
                    }
                  },
                );
              }
              return SigninScreen();
            },
          ),
          initialRoute: '/',
          routes: {
            PostAdScreen.routeName: (ctx) => PostAdScreen(),
            FeedScreen.routeName: (ctx) => FeedScreen(),
            ProfileScreen.routeName: (ctx) => ProfileScreen(),
            TabScreen.routeName: (ctx) => TabScreen(),
            UserAdsScreen.routeName: (ctx) => UserAdsScreen(),
          }),
    );
  }
}
