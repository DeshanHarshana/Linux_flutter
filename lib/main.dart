import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:stream_guide/home.dart';
import 'package:stream_guide/searchPage.dart';
import 'package:stream_guide/stream.dart';
import 'package:stream_guide/stream2.dart';

import 'image_add.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Str2(),
        routes: <String, WidgetBuilder>{
          '/search': (BuildContext context) => new SearchPage(),
           '/add': (BuildContext context) => new Str2(),
            '/upload': (BuildContext context) => new Image_Capture(),
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('dsfs'),
      ),
    );
  }
}

class Uploder extends StatefulWidget {
  final File file;

  Uploder({Key key, this.file}) : super(key: key);

  createState() => UploderState();
}

class UploderState extends State<Uploder> {
  String location='https://cm3inc.com/wp-content/uploads/2016/08/npa2.jpg';
  String collection;
  String docID;
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://grounded-camp-277014.appspot.com');
  StorageUploadTask _uploadTask;

  void setDetails(String col, String docid){
    setState(() {
      this.collection=col;
    this.docID=docid;
    });
  }

  Future<void> startUpload() async {
    String filepath = "images/${DateTime.now()}.png";

    setState(() {
      _uploadTask = _storage.ref().child(filepath).putFile(widget.file);
      
    });
    
     StorageTaskSnapshot snapshottask =  await _uploadTask.onComplete;
      String downloadUrl = await snapshottask.ref.getDownloadURL();
     if (downloadUrl !=null){
       setState(() {
         location=downloadUrl;
       });
     
     
    
  
     }
    Firestore.instance.collection('Books').document(collection).collection(collection).document(docID).updateData({
      'cover':location
    }).whenComplete(() => {
      Navigator.of(context).pushReplacementNamed('/add')
    });
  }
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
        stream: _uploadTask.events,
        builder: (context, snapshot) {
          var event = snapshot?.data?.snapshot;

          double progressPresent =
              event != null ? event.bytesTransferred / event.totalByteCount : 0;

          return Column(
            children: <Widget>[
              if (_uploadTask.isComplete) Text('Success'),
              if (_uploadTask.isPaused)
                FlatButton(
                  child: Icon(Icons.play_arrow),
                  onPressed: () {
                    _uploadTask.resume();
                  },
                ),
              if (_uploadTask.isInProgress)
                FlatButton(
                  child: Icon(Icons.pause),
                  onPressed: () {
                    _uploadTask.pause();
                  },
                ),

                LinearProgressIndicator(value: progressPresent,),
                Text('${(progressPresent*100).toStringAsFixed(2)}%')
            ],
          );
        },
      );
    } else {
      return FlatButton.icon(
        label: Text('Upload'),
        icon: Icon(Icons.cloud_upload),
        onPressed: () {
          startUpload();
        },
      );
    }
  }
}
