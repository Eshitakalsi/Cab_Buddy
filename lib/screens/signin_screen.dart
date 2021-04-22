import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';

import '../animation/fade_animation.dart';

class SigninScreen extends StatefulWidget {
  @override
  _SigninSreenState createState() => _SigninSreenState();
}

class _SigninSreenState extends State<SigninScreen> {
  bool _isLoading = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _loginWithGoogle() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await GoogleSignIn().signOut();
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
    } on PlatformException catch (err) {
      setState(() {
        _isLoading = false;
      });
      var message = 'An error occured, please check your credentials!';
      if (err.message != null) {
        message = err.message;
      }
      print(err.message);
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  FadeAnimation(
                    1,
                    Text(
                      "Welcome",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  FadeAnimation(
                    1.2,
                    Text(
                      "We hope you have a great day!",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ),
                ],
              ),
              FadeAnimation(
                1.4,
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/car.png'),
                    ),
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  _isLoading
                      ? Container(
                          child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Colors.black87),
                          ),
                        )
                      : FadeAnimation(
                          1.6,
                          Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border(
                                bottom: BorderSide(color: Colors.black),
                                top: BorderSide(color: Colors.black),
                                left: BorderSide(color: Colors.black),
                                right: BorderSide(color: Colors.black),
                              ),
                            ),
                            child: MaterialButton(
                              minWidth: double.infinity,
                              height: 60,
                              onPressed: () {
                                _loginWithGoogle();
                              },
                              color: Colors.black87,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Text(
                                "Signup with Google",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
