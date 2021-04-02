import 'package:flutter/material.dart';

import '../models/feed_data.dart';

class FeedScreen extends StatelessWidget {

  var feedData = FeedData.getData;
  @override
  Widget build(BuildContext context) {
return MaterialApp(
  debugShowCheckedModeBanner: false,
       home: Scaffold(
         resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(30.0),
              child: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
        ),
      ),
           body: Container(
             child: Column(
               mainAxisSize: MainAxisSize.max,
               mainAxisAlignment: MainAxisAlignment.start,
               children: <Widget>[
                 Expanded(
                   child: ListView.builder(
// scrollDirection: Axis.horizontal,
                   itemCount: feedData.length,
                   itemBuilder: (context, index) {
                     return Container(
                       padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                       height: 220,
                       width: double.maxFinite,
                       child: Card(
                         elevation: 5,
                         child: Container(
                           child: Padding(
                             padding: EdgeInsets.all(7),
                             child: Stack(children: <Widget>[
                               Align(
                                 alignment: Alignment.centerRight,
                                 child: Stack(
                                   children: <Widget>[
                                     Padding(
                                         padding: const EdgeInsets.only(left: 10, top: 5),
                                         child: Column(
                                           children: <Widget>[
                                             Row(
                                               children: <Widget>[
                                                 infoIcon(),
                                               SizedBox(
                                                 height: 10,
                                               ),
                                               authorDetails(feedData[index]),
                                               Spacer(),
                                               timings(feedData[index]),
                                               SizedBox(
                                                 width: 10,
                                               ),
                                               carIcon(),
                                               SizedBox(
                                                 width: 20,
                                               )
                                             ],
                                           ),
                                           Row(
                                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                           children: <Widget>[
                                             locationDetails(feedData[index]),
                                             RaisedButton(
                                               child: Text('Join')
                                               ,onPressed: (){
                                             },
                                             )
                                           ],
                                         )
                                       ],
                                      ))
                                 ],
                               ),
                             )
                           ]),
                         ),
                           decoration: BoxDecoration(
                             border: Border(
                               top: BorderSide(
                                   width: 2.0, color: Colors.yellow[100],
                             ),
                           ),
                           color: Colors.white,
                       ),
                     ),
                   ),
                     );
                 },
                 ),
           ),
         ],
       ),
     )));
 }
 Widget infoIcon() {
   return Padding(
     padding: const EdgeInsets.only(left: 15.0),
     child: Align(
         alignment: Alignment.centerLeft,
         child: Icon(
           Icons.info,
           color: Colors.amber,
           size: 40,
         )),
   );
 }
 Widget authorDetails(data) {
   return Align(
     alignment: Alignment.centerLeft,
     child: RichText(
       text: TextSpan(
         text: '${data['name']}',
         style: TextStyle(
             fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
         children: <TextSpan>[
           TextSpan(
               text: '\n${data['year']}',
               style: TextStyle(
                   color: Colors.grey,
                   fontSize: 15,
                   fontWeight: FontWeight.bold)),
         ],
       ),
     ),
   );
  }
Widget timings(data) {
  return Align(
    alignment: Alignment.topRight,
    child: RichText(
      text: TextSpan(
        text: 'Pick Up',
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.green, fontSize: 20),
        children: <TextSpan>[
        TextSpan(
            text: '\n${data['time']}',
            style: TextStyle(
                color: Colors.green,
                fontSize: 15,
                fontWeight: FontWeight.bold)),
      ],
    ),
  ),
);
}
Widget carIcon() {
  return Align(
      alignment: Alignment.topRight,
      child: Icon(
        Icons.time_to_leave,
        color: Colors.green,
        size: 30,
      ));
}
Widget locationDetails(data) {
  return Align(
  alignment: Alignment.centerLeft,
  child: Padding(
    padding: const EdgeInsets.only(left: 20.0),
    child: Row(
      children: <Widget>[
        RichText(
          textAlign: TextAlign.left,
          text: TextSpan(
            text: '\n${data['to']}',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 20,
            ),
            children: <TextSpan>[
              TextSpan(
                  text: '\n${data['from']}',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      )),
            ],
          ),
        ),
      ],
    ),
  ),
  );
 }
}