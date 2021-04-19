import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/loggedIn_user_info.dart';
import '../screens/tab_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/joined_ad_screen.dart';
import '../widgets/info_card.dart';

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
            title: Text(
              'Hey There!',
              style: TextStyle(color: Colors.white),
            ),
            automaticallyImplyLeading: false,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              Navigator.pushReplacementNamed(context, TabScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Profile"),
            onTap: () {
              Navigator.pushReplacementNamed(context, ProfileScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.queue),
            title: Text("Joined Ad"),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => JoinedAdScreen()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
            onTap: () {
              googleSignOut(context);
            },
          ),
          Divider(),
        ],
      ),
    ));
  }
}
