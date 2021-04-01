import 'package:cab_buddy/animation/FadeAnimation.dart';
import 'package:cab_buddy/models/loggedInUserInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class PostAdd extends StatefulWidget {
  static const routeName = "/PostAdd";

  @override
  _PostAddState createState() => _PostAddState();
}

class _PostAddState extends State<PostAdd> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _isLoading = false;
  String _vacancy = null;
  String _locationFrom = null;
  String _locationTo = null;

  List<String> _locations = [
    'JIIT 62',
    'JIIT 128',
    'Noida Electronic City',
    'Vaishali Metro Station',
    'Shipra Mall'
  ];
  List<String> _vacancies = ['1', '2', '3'];
  List<String> _gates = ['1', '2', '3'];
  final format = DateFormat("yyyy-MM-dd");
  DateTime time = null;
  TimeOfDay t = null;
  DateTime date = null;
  static final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Future<void> _submitUserInformation() async {
      setState(() {
        _isLoading = true;
      });
      try {
        int adCount = 0;
        await Firestore.instance
            .collection('Ads')
            .where('userId', isEqualTo: LoggedInUserInfo.id)
            .getDocuments()
            .then((value) {
          adCount = value.documents.length;
        });
        if (adCount == 1) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('You cant create two ads'),
            backgroundColor: Theme.of(context).errorColor,
          ));
          setState(() {
            _isLoading = false;
          });
          return;
        }
        await Firestore.instance.collection('Ads').add({
          'pickup': _locationFrom,
          'drop:': _locationTo,
          'vacancy': _vacancy,
          'date': date,
          'userId': LoggedInUserInfo.id,
          'joinedUsers': [],
        });
        await Firestore.instance.collection('Chats').add({
          'userId': LoggedInUserInfo.id,
          'joinedUsers': [],
        });
        setState(() {
          _isLoading = false;
        });
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
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Please fill all the fields'),
          backgroundColor: Theme.of(context).errorColor,
        ));
        return;
      }
      date = DateTimeField.combine(time, t);
      if (date.isBefore(DateTime.now())) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Please enter correct Time'),
          backgroundColor: Theme.of(context).errorColor,
        ));
        return;
      }
      if (_locationFrom == _locationTo) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Pickup and Drop cannot be same'),
          backgroundColor: Theme.of(context).errorColor,
        ));
        return;
      }
      _submitUserInformation();
    }

    return Scaffold(
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
                child: Column(children: <Widget>[
                  FadeAnimation(
                      1,
                      Text(
                        "Post An Ad",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                      key: _formKey,
                      child: Column(mainAxisSize: MainAxisSize.min, children: <
                          Widget>[
                        DropdownButton<String>(
                          hint: _locationFrom == null
                              ? Text('Select Pickup Location')
                              : Text(
                                  'From: ${_locationFrom}',
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
                              : Text('To: ${_locationTo}'),
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
                              : Text('Vacancies: ${_vacancy}'),
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
                                  initialDate:
                                      time == null ? DateTime.now() : time,
                                  lastDate:
                                      DateTime.now().add(Duration(days: 1)));
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
                                height: MediaQuery.of(context).size.height / 7,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/car.gif'),
                                  ),
                                ),
                              )
                            : MaterialButton(
                                minWidth: double.infinity,
                                height: 60,
                                onPressed: () {
                                  print("hello");
                                  _trySubmit();
                                },
                                color: Colors.greenAccent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                child: Text(
                                  "Post Ad",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                              ),
                      ]))
                ]))));
  }
}
