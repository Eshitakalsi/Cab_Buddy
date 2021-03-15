import 'dart:io';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:cab_buddy/models/loggedInUserInfo.dart';
import 'package:cab_buddy/screen/homePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserFormScreen extends StatefulWidget {
  final String _uid;
  final String _email;
  UserFormScreen(this._uid, this._email);
  @override
  _UserFormScreenState createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  static final _formKey = GlobalKey<FormState>();
  bool _hasUserDataAlready = false;
  var _isLoading = false;
  var _firstname = ' ';
  var _lastname = ' ';
  var _batch = null;
  var _year = null;
  var _gender = null;
  var _sector = null;
  List<String> _batches = ['B1', 'B2', 'B3', 'B4'];
  List<String> _genders = ['M', 'F'];
  List<String> _sectors = ['62', '128'];
  List<String> _years = ['1', '2', '3', '4', '5'];

  Future<void> _submitUserInformation(
      String firstName,
      String lastName,
      String batch,
      String gender,
      String sector,
      String year,
      BuildContext ctx) async {
    try {
      setState(() {
        _isLoading = true;
      });

      await Firestore.instance
          .collection('users')
          .document(widget._uid)
          .setData({
        'firstName': firstName,
        'lastName': lastName,
        'batch': batch,
        'gender': gender,
        'sector': sector,
        'year': year,
      });
      setState(() {
        _isLoading = false;
        _hasUserDataAlready = true;
      });
    } on PlatformException catch (err) {
      setState(() {
        _isLoading = false;
      });
      var message = 'An error occured, please check your credentials!';
      if (err.message != null) {
        message = err.message;
      }
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).errorColor,
      ));
    } on HttpException catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
            "Please check your Internet Connection",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor));
    } on AuthException catch (err) {
      setState(() {
        _isLoading = false;
      });
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          err.message,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).errorColor,
      ));
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    void _trySubmit() {
      final isValid = _formKey.currentState.validate();
      FocusScope.of(context).unfocus();
      if (isValid &&
          _batch != null &&
          _year != null &&
          _gender != null &&
          _sector != null) {
        print('Jello');
        _formKey.currentState.save();
        _submitUserInformation(_firstname.trim(), _lastname.trim(), _batch,
            _gender, _sector, _year, context);
      } else {
        print('BS');
        return;
      }
    }

    Widget userInfoForm = Scaffold(
      body: Center(
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          elevation: 5,
          margin: EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
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
                      items: _years.map((String val) {
                        return new DropdownMenuItem<String>(
                          value: val,
                          child: new Text(val),
                        );
                      }).toList(),
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
                      items: _batches.map((String val) {
                        return new DropdownMenuItem<String>(
                          value: val,
                          child: new Text(val),
                        );
                      }).toList(),
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
                      items: _genders.map((String val) {
                        return new DropdownMenuItem<String>(
                          value: val,
                          child: new Text(val),
                        );
                      }).toList(),
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
                      items: _sectors.map((String val) {
                        return new DropdownMenuItem<String>(
                          value: val,
                          child: new Text(val),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        _sector = newVal;
                        this.setState(() {});
                      },
                    ),
                    _isLoading
                        ? CircularProgressIndicator()
                        : RaisedButton(
                            color: Colors.blueGrey[100],
                            child: Text('Submit'),
                            onPressed: () {
                              _trySubmit();
                            },
                          ),
                  ],
                ),
              ),
            ),
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

      return HomePage();
    } else {
      return userInfoForm;
    }
  }
}
