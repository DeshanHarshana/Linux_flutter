import 'package:flutter/material.dart';
import 'package:full_text_search/Database.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: Database().getName(),
          builder: (context, snapshot){
              if(snapshot.connectionState==ConnectionState.done){
                return Text(snapshot.data);
              }
              else{
                return CircularProgressIndicator();
              }
          },
        ),
      ),
    );

  }
}