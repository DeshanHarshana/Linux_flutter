import 'package:flutter/material.dart';
import 'Database.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String name="dfd";

  Widget item=Text("Hey");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

          item,
          FlatButton(
            color: Colors.blue,
            child: Text("Click Me"),
            
            onPressed: (){
              setState(() {
                this.item=setData();
              });
              
            },
          
          )
          
        ],)
      ),
    );

  }
  Widget setData(){
    return FutureBuilder(
          future: Database().getName(),
          builder: (context, snapshot){
              if(snapshot.connectionState==ConnectionState.done){
                return Text(snapshot.data);
              }
              else{
                return CircularProgressIndicator();
              }
          },
        );

  }
          
  
}