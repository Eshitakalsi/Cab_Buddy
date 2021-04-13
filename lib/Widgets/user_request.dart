import 'package:flutter/material.dart';

class UserRequest extends StatelessWidget {
  final snapshot;
  UserRequest(this.snapshot);
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
              image: NetworkImage(snapshot.data['image_url']),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          snapshot.data['firstName'],
          style: TextStyle(fontSize: 20),
        ),
        subtitle: Row(
          children: [
            Text('Year: ${snapshot.data['year']}'),
            SizedBox(
              width: 20,
            ),
            Text('Batch: ${snapshot.data['batch']}'),
          ],
        ),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                  icon: Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                  onPressed: () {}),
              IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                  onPressed: () {})
            ],
          ),
        ));
  }
}
