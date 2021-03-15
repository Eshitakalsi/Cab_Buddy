import 'package:cab_buddy/models/loggedInUserInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatelessWidget {
  Future<void> googleSignOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Welcome!   " + LoggedInUserInfo.name),
            RaisedButton(
                child: Text("Sign out"),
                onPressed: () {
                  googleSignOut();
                }),
          ],
        ),
      ),
    );
  }
}
