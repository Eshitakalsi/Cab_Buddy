import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:overlay_support/overlay_support.dart';

import '../models/loggedIn_user_info.dart';

class PostAdScreen extends StatefulWidget {
  static const routeName = "/postAdScreen";

  @override
  _PostAdScreenState createState() => _PostAdScreenState();
}

class _PostAdScreenState extends State<PostAdScreen> {
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

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _isLoading = false;
  String _vacancy;
  String _locationFrom;
  String _locationTo;

  List<String> _locations = [
    'JIIT 62',
    'JIIT 128',
    'Noida',
    'Vaishali',
    'Shipra'
  ];
  List<String> _vacancies = ['1', '2', '3'];
  // List<String> _gates = ['1', '2', '3'];
  final format = DateFormat("yyyy-MM-dd");
  DateTime time;
  TimeOfDay t;
  DateTime date;
  static final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Future<void> _submitUserInformation() async {
      setState(() {
        _isLoading = true;
      });
      try {
        // int adCount = 0;
        var doc = await Firestore.instance
            .collection('Ads')
            .document(LoggedInUserInfo.id)
            .get();
        if (doc.exists) {
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text('You cant create two ads'),
              backgroundColor: Theme.of(context).errorColor,
            ),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }
        List<String> splitList = _locationFrom.split(" ");
        List<String> indexList = [];
        for (int i = 0; i < splitList.length; i++) {
          for (int j = 1; j <= splitList[i].length; j++) {
            indexList.add(splitList[i].substring(0, j).toLowerCase());
          }
        }
        await Firestore.instance
            .collection('Ads')
            .document(LoggedInUserInfo.id)
            .setData({
          'pickup': _locationFrom,
          'drop': _locationTo,
          'vacancy': _vacancy,
          'date': date,
          'joinedUsers': [],
          'requestedUsers': [],
          'searchIndex': indexList,
        });
        await Firestore.instance
            .collection('Chats')
            .document(LoggedInUserInfo.id)
            .setData({});

        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      } on AuthException catch (e) {
        print(e);
        setState(() {
          _isLoading = false;
        });
      } on PlatformException catch (e) {
        print(e);
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        print(e);
        setState(() {
          _isLoading = false;
        });
      }
    }

    void _trySubmit() {
      FocusScope.of(context).unfocus();
      if (_locationFrom == null ||
          _locationTo == null ||
          _vacancy == null ||
          time == null ||
          t == null) {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text('Please fill all the fields'),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
        return;
      }
      date = DateTimeField.combine(time, t);
      if (date.isBefore(DateTime.now())) {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text('Please enter correct Time'),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
        return;
      }
      if (_locationFrom == _locationTo) {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text('Pickup and Drop cannot be same'),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
        return;
      }
      _submitUserInformation();
    }

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Post An Ad'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    DropdownButton<String>(
                      hint: _locationFrom == null
                          ? Text('Select Pickup Location')
                          : Text(
                              'From: $_locationFrom',
                            ),
                      items: _locations.map((String val) {
                        return new DropdownMenuItem<String>(
                          value: val,
                          child: new Text(val),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        _locationFrom = newVal;
                        this.setState(() {});
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    DropdownButton<String>(
                      hint: _locationTo == null
                          ? Text('Select Drop Location')
                          : Text('To: $_locationTo'),
                      items: _locations.map((String val) {
                        return new DropdownMenuItem<String>(
                          value: val,
                          child: new Text(val),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        _locationTo = newVal;
                        this.setState(() {});
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    DropdownButton<String>(
                      hint: _vacancy == null
                          ? Text('Select number of vacancies')
                          : Text('Vacancies: $_vacancy'),
                      items: _vacancies.map((String val) {
                        return new DropdownMenuItem<String>(
                          value: val,
                          child: new Text(val),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        _vacancy = newVal;
                        this.setState(() {});
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    ListTile(
                      leading: Icon(Icons.calendar_today_outlined),
                      title: time == null
                          ? Text("Select Date")
                          : Text(format.format(time)),
                      trailing: FlatButton(
                        child: Text("Change"),
                        onPressed: () async {
                          final date = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              initialDate: time == null ? DateTime.now() : time,
                              lastDate: DateTime.now().add(Duration(days: 1)));
                          setState(() {
                            time = date;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    ListTile(
                      leading: Icon(Icons.lock_clock),
                      title: t == null
                          ? Text("Select Time")
                          : Text(t.format(context)),
                      trailing: FlatButton(
                        child: Text("Change"),
                        onPressed: () async {
                          final timeT = await showTimePicker(
                              context: context,
                              initialTime:
                                  TimeOfDay.fromDateTime(DateTime.now()));
                          setState(() {
                            t = timeT;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    _isLoading
                        ? Container(
                            // height: MediaQuery.of(context).size.height / 7,
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.black87),
                            ),
                          )
                        : MaterialButton(
                            minWidth: double.infinity,
                            height: 60,
                            onPressed: () {
                              print("hello");
                              _trySubmit();
                            },
                            color: Colors.black87,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            child: Text(
                              "Post Ad",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
