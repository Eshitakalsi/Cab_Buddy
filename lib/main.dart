import 'package:cab_buddy/screen/errorScreen.dart';
import 'package:cab_buddy/screen/homePage.dart';
import 'package:cab_buddy/screen/signInPage.dart';
import 'package:cab_buddy/screen/splashScreen.dart';
import 'package:cab_buddy/screen/userFormScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'models/loggedInUserInfo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Home Page',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          accentColor: Colors.amber,
          errorColor: Colors.red,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (ctx, AsyncSnapshot<FirebaseUser> userSnapshot) {
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

                        return HomePage();
                      } else {
                        return UserFormScreen(
                            userSnapshot.data.uid, userSnapshot.data.email);
                      }
                    }
                  });
            }
            return SigninScreen();
          },
        ));
  }
}
