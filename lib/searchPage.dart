import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String name = "";
  String searchString;
  String doc = 'english';

  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: 120,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: doc,
                  style: TextStyle(fontSize: 12, color: Colors.deepPurple),
                  onChanged: (String newValue) {
                    setState(() {
                      doc = newValue;
                    });
                  },
                  items: <String>[
                    'english',
                    'mathematics',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          )
        ],
        title: TextField(
          onChanged: (val) {
            setState(() {
              searchString = val.toLowerCase();
            });
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: (searchString == null || searchString.trim() == "")
                        ? Firestore.instance
                            .collection('Books')
                            .document(doc)
                            .collection(doc)
                            .snapshots()
                        : Firestore.instance
                            .collection("Books")
                            .document(doc)
                            .collection(doc)
                            .where("searchIndex", arrayContains: searchString)
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error');
                      }
                      switch (snapshot.connectionState) {
                        case (ConnectionState.waiting):
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        default:
                          return new GridView.count(
                            crossAxisCount: 2,
                            children: List.generate(
                                snapshot.data.documents.length, (index) {
                              return Center(
                                
                                child: Image.network(snapshot.data.documents[index].data['cover'], fit: BoxFit.cover,),
                                
                                
                                
                              );
                            }),
                          );
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
