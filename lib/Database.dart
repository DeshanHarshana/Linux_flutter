

import 'package:cloud_firestore/cloud_firestore.dart';

class Database{
  final _firestore=Firestore.instance;

  Future<String> getName() async{
    String name;
    try{
      DocumentSnapshot snapshot=await _firestore.collection("clients").document('name').get();
      name=snapshot.data['Name'];
    }catch(e){
      print(e);
    }

    return Future.delayed(Duration(seconds: 3)).then((value) => name);
  }

  
}