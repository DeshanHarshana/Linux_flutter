import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Str extends StatefulWidget {
  @override
  _StrState createState() => _StrState();
}

class _StrState extends State<Str> {
  Widget _buildList(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      title: Text(document['Name']),
      
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Get Specific value"),),
      body: StreamBuilder(
        stream: Firestore.instance.collection('clients').document('name').snapshots(),
        //print an integer every 2secs, 10 times
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading..");
          }
          return ListView.builder(
            itemExtent: 80.0,
            itemCount: 1,
            itemBuilder: (context, index) {
              return _buildList(context, snapshot.data);
            },
          );
        },
      
    ));
  }
}