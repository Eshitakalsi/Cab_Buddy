import 'package:cab_buddy/Widgets/userRequest.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RequestLists extends StatelessWidget {
  List requestLists;
  RequestLists(this.requestLists);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          title: Text("Requests"),
        ),
      ),
      body: ListView.builder(
          itemCount: requestLists.length,
          itemBuilder: (context, index) {
            return FutureBuilder(
              future: Firestore.instance
                  .collection('users')
                  .document(requestLists[index])
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                }
                return UserRequest(snapshot);
              },
            );
          }),
    );
  }
}
