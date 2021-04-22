import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:image_picker/image_picker.dart';

import '../pickers/user_image_picker.dart';
import '../animation/fade_animation.dart';
import '../models/loggedIn_user_info.dart';
import './tab_screen.dart';

class UserFormScreen extends StatefulWidget {
  final String _uid;
  final String _email;
  UserFormScreen(this._uid, this._email);
  @override
  _UserFormScreenState createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  static final _formKey = GlobalKey<FormState>();
  bool _hasUserDataAlready = false;
  var _isLoading = false;
  var _firstname = ' ';
  var _lastname = ' ';
  var _batch;
  var _year;
  var _gender;
  var _sector;
  var _imageURL = '';
  var _favorites = [];
  File _userImageFile;
  List<String> _batches = ['B1', 'B2', 'B3', 'B4', 'B5', 'B6', 'B7'];
  List<String> _genders = ['M', 'F'];
  List<String> _sectors = ['62', '128'];
  List<String> _years = ['1', '2', '3', '4', '5'];
  void _pickedImage(PickedFile image) {
    _userImageFile = File(image.path);
  }

  Future<void> _submitUserInformation(
      String firstName,
      String lastName,
      String batch,
      String gender,
      String sector,
      String year,
      File image,
      BuildContext ctx) async {
    try {
      setState(
        () {
          _isLoading = true;
        },
      );
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child(widget._uid + '.jpg');
      await ref.putFile(image).onComplete;
      final url = await ref.getDownloadURL();
      _imageURL = url;
      await Firestore.instance
          .collection('users')
          .document(widget._uid)
          .setData(
        {
          'firstName': firstName,
          'lastName': lastName,
          'batch': batch,
          'gender': gender,
          'sector': sector,
          'year': year,
          'image_url': url,
          'favorites': [],
        },
      );
      setState(
        () {
          _isLoading = false;
          _hasUserDataAlready = true;
        },
      );
    } on PlatformException catch (err) {
      setState(() {
        _isLoading = false;
      });
      var message = 'An error occured, please check your credentials!';
      if (err.message != null) {
        message = err.message;
      }
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } on HttpException catch (err) {
      print(err);
      setState(
        () {
          _isLoading = false;
        },
      );
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please check your internet connection.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } on AuthException catch (err) {
      setState(
        () {
          _isLoading = false;
        },
      );
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            err.message,
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } catch (error) {
      setState(
        () {
          _isLoading = false;
        },
      );
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    void _trySubmit() {
      final isValid = _formKey.currentState.validate();
      FocusScope.of(context).unfocus();
      if (_userImageFile == null) {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text('Please pick an image'),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
        return;
      }
      if (isValid &&
          _batch != null &&
          _year != null &&
          _gender != null &&
          _sector != null) {
        _formKey.currentState.save();
        _submitUserInformation(_firstname.trim(), _lastname.trim(), _batch,
            _gender, _sector, _year, _userImageFile, context);
      } else {
        return;
      }
    }

    Widget userForm = Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  FadeAnimation(
                      1,
                      Text(
                        "Sign up",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        UserImagePicker(_pickedImage),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'FirstName'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter your First Name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _firstname = value;
                          },
                          key: ValueKey('firstName'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'LastName'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter your Last Name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _lastname = value;
                          },
                          key: ValueKey('lastName'),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        DropdownButton<String>(
                          hint: _year == null
                              ? Text('Select Your Year')
                              : Text(
                                  _year,
                                ),
                          items: _years.map(
                            (String val) {
                              return new DropdownMenuItem<String>(
                                value: val,
                                child: new Text(val),
                              );
                            },
                          ).toList(),
                          onChanged: (newVal) {
                            _year = newVal;
                            this.setState(() {});
                          },
                        ),
                        DropdownButton<String>(
                          hint: _batch == null
                              ? Text('Select Your Batch')
                              : Text(
                                  _batch,
                                ),
                          items: _batches.map(
                            (String val) {
                              return new DropdownMenuItem<String>(
                                value: val,
                                child: new Text(val),
                              );
                            },
                          ).toList(),
                          onChanged: (newVal) {
                            _batch = newVal;
                            this.setState(() {});
                          },
                        ),
                        DropdownButton<String>(
                          hint: _gender == null
                              ? Text('Select Your Gender')
                              : Text(
                                  _gender,
                                ),
                          items: _genders.map(
                            (String val) {
                              return new DropdownMenuItem<String>(
                                value: val,
                                child: new Text(val),
                              );
                            },
                          ).toList(),
                          onChanged: (newVal) {
                            _gender = newVal;
                            this.setState(() {});
                          },
                        ),
                        DropdownButton<String>(
                          hint: _sector == null
                              ? Text('Select Sector')
                              : Text(
                                  _sector,
                                ),
                          items: _sectors.map(
                            (String val) {
                              return new DropdownMenuItem<String>(
                                value: val,
                                child: new Text(val),
                              );
                            },
                          ).toList(),
                          onChanged: (newVal) {
                            _sector = newVal;
                            this.setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
              _isLoading
                  ? Container(
                      child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.black87),
                      ),
                    )
                  : FadeAnimation(
                      1.5,
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
                            _trySubmit();
                          },
                          color: Colors.black87,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );

    if (_hasUserDataAlready) {
      LoggedInUserInfo.id = widget._uid;
      LoggedInUserInfo.name = _firstname + " " + _lastname;
      LoggedInUserInfo.email = widget._email;
      LoggedInUserInfo.batch = _batch;
      LoggedInUserInfo.sector = _sector;
      LoggedInUserInfo.gender = _gender;
      LoggedInUserInfo.year = _year;
      LoggedInUserInfo.url = _imageURL;
      LoggedInUserInfo.favorites = _favorites;
      return TabScreen();
    } else {
      return userForm;
    }
  }
}
