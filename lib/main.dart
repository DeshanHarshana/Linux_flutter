import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:full_text_search/serchService.dart';

import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
     
      home: Home(),
    );
  }
}

class MyHomePage extends StatefulWidget {
 
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var queryResultSet = [];
  var tempSearchStore = [];
  initiateSearch(val) {
    if (val.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue = val.substring(0, 1).toUpperCase() + val.substring(1);

    if (queryResultSet.length == 0 && val.length == 1) {
      SearchService().searchByname(val).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; i++) {
          queryResultSet.add(docs.documents[i].data);
          tempSearchStore.add(queryResultSet[i]);
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['BusinessName'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
        appBar: AppBar(
            title: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Search Data...",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white30),
          ),
          style: TextStyle(color: Colors.white, fontSize: 26.0),
          onChanged: ((val) {
            initiateSearch(val);
          }),
        )),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
            ),
            SizedBox(
              height: 10.0,
            ),
            GridView.count(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              primary: false,
              shrinkWrap: true,
              children: tempSearchStore.map((e) {
                return buildResuldCard(e);
              }).toList(),
            ),
          ],
        ));
  }

  Widget buildResuldCard(data) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 2,
      child: Container(
        child: Center(
          child: Text(
            data['BusinessName'],
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontSize: 14.0),
          ),
        ),
      ),
    );
  }
}
