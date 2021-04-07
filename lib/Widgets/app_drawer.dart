import 'package:cab_buddy/models/loggedInUserInfo.dart';
import 'package:cab_buddy/screen/feedScreen.dart';
import 'package:cab_buddy/screen/profilePage.dart';
import 'package:cab_buddy/screen/tabScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AppDrawer extends StatelessWidget {
  Future<void> googleSignOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    LoggedInUserInfo.id = null;
    LoggedInUserInfo.name = null;
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Feed"),
            onTap: () {
              Navigator.pushReplacementNamed(context, TabScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text("Profile"),
            onTap: () {
              Navigator.pushReplacementNamed(context, ProfilePage.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
            onTap: () {
              googleSignOut(context);
            },
          ),
        ],
      ),
    ));
  }
}
