import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ErrorScreen extends StatelessWidget {
  Future<void> googleSignOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(child: Text("Please Use JIIT EMAIL")),
        RaisedButton(
            child: Text("Return to Login Screen"),
            onPressed: () {
              googleSignOut();
            }),
      ],
    ));
  }
}
