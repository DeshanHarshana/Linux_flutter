import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stream_guide/main.dart';

import 'searchPage.dart';


class Str2 extends StatefulWidget {
  @override
  _Str2State createState() => _Str2State();
}

class _Str2State extends State<Str2> {
  final name= TextEditingController();
  final author = TextEditingController();
  
  String searchString;

  String catogory = 'Catogory';
  Widget _buildList(BuildContext context, DocumentSnapshot document, String collection, String doc, String subCol) {
    return ListTile(
      onLongPress: (){
        showAlertDialog(context, document.documentID, collection,doc,subCol);
      },
      
      title: Text(document['name'], style: TextStyle(fontSize: 18),),
      subtitle: Text(document['author']),
      
    );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
        appBar: AppBar(title: FlatButton(child: Text('Search Page'),onPressed: (){
          Navigator.of(context).pushReplacementNamed('/search');
        },),),
        body: SingleChildScrollView(
                  child: Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(children: <Widget>[
                  Container(height: 80,
                  width: 150,
                  child: TextFormField(
                  
                    decoration: const InputDecoration(
                    
                    hintText: 'Book Name',
                    
                    ),
                    
                    controller: name,
                    ),
                  ),
                  Container(height: 80,
                  width: 150,
                  child: TextFormField(
                    controller: author,
                    decoration: const InputDecoration(
                    
                    hintText: 'Author Name',
                   
                    ),
                   
                    ),
                  ),
                   Container(height: 80,
                  width: 150,
                  child: TextFormField(
                    decoration: const InputDecoration(
                    
                    hintText: 'Search Book',
                   
                    ),
                    onChanged: (value){
                      setState(() {
                        searchString=value;
                      });
                    },
                    ),
                  )

                ],),
                Column(children: <Widget>[
                  Container(
                                width: 120,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: catogory,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.deepPurple),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        catogory = newValue;
                                      });
                                    },
                                    items: <String>[
                                      'Catogory',
                                      'english',
                                      'mathematics',

                                    ].map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ))),
                  FlatButton(child: Text('Add'),color: Colors.blueGrey,
                  onPressed: (){
                    try{
                      Firestore.instance.collection('Books').document(catogory).collection(catogory).add({
                        'name' : name.text,
                        'author' : author.text


                    }).then((value) => {
                      
                        addToDatabase(name.text,"Books",catogory,catogory,value.documentID),
                        print('success'),
                        UploderState().setDetails(catogory, value.documentID),
                        Navigator.of(context).pushReplacementNamed('/upload')
                       
                    });
                    }catch(e){
                      print(e);
                    }

                    
                    
                  },
                  )

                ],)

            ],),
            
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                StreamBuilder<QuerySnapshot>(
                    stream:(searchString==null || searchString.trim()=="")
                    ? Firestore.instance.collection('Books')
                      .document('english').collection('english').snapshots()
                      : Firestore.instance.collection("Books").document('english')
                        .collection('english').where("searchIndex", arrayContains: searchString).snapshots(),
                      builder: (context,snapshot){
                        if(snapshot.hasError){
                          return Text('Error');
                        }
                        switch(snapshot.connectionState){
                          case (ConnectionState.waiting):
                            return Center(child: CircularProgressIndicator(),);
                          default:
                            return Container(
                              width: 120,
                              height: 300,
                              child: ListView.builder(
                      
                        itemExtent: 80.0,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          return _buildList(context,snapshot.data.documents[index],"Books","english","english");
                        },
                    ),
                            );
                        }
                      },
                  ),

           StreamBuilder(
            stream: Firestore.instance.collection('Books').document('mathematics').collection('mathematics').snapshots(),
            //print an integer every 2secs, 10 times
            builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                      return Text("Loading..");
                  }
                  return Container(
                    width: 120,
                    height: 300,
                   
                    child: ListView.builder(
                      
                        itemExtent: 80.0,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          return _buildList(context,snapshot.data.documents[index],"Books","mathematics","mathematics");
                        },
                    ),
                  );
            },
          
      
       
          ),
                    
                  
              ])
          ],),
        )
            
        ),
    );
  }

  showAlertDialog(BuildContext context, String id, String collection, String doc, String subcol) {

  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Dont't delete"),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  );
  Widget editButton = FlatButton(
    child: Text("Edit"),
    onPressed:  () {
      Navigator.of(context).pop();
      showEditDialog(context, id, collection, doc, subcol);
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Delete"),
    onPressed:  () async {
      await Firestore.instance.collection(collection).document(doc).collection(subcol).document(id).delete().then((value) => {
        print('delete success'),
        Navigator.of(context).pop()
      });
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("AlertDialog"),
    content: Text("Would you like to delete this book?"),
    actions: [
      cancelButton,
      continueButton,
      editButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}


showEditDialog(BuildContext context, String id, String collection, String doc, String subcol) {
  String newName="";
  String newAuthor="";
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Dont't Edit"),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Edit"),
    onPressed:  () async {
      await Firestore.instance.collection(collection).document(doc).collection(subcol).document(id).updateData({
        'author':newAuthor,
        'name' : newName
      })
      
      
      .then((value) => {
        print('Edit success'),
        Navigator.of(context).pop()
      });
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("AlertDialog"),
    content: Column(children: <Widget>[
      
  // set up the buttons
  TextFormField(
                
                  decoration: const InputDecoration(
                  
                  hintText: 'Book Name',
                  
                  ),
                  onChanged: (value){
                    setState(() {
                      newName=value;
                    });
                  },),

                  TextFormField(
                
                  decoration: const InputDecoration(
                  
                  hintText: 'Author name',
                  
                  ),
                  onChanged: (value){
                    setState(() {
                      newAuthor=value;
                    });
                  },),
    ],),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void addToDatabase(String name, String collecion, String doc, String subCol,String id){
    List<String> splitList=name.split(" ");
    List<String> indexList=[];

    for(int i=0; i<splitList.length; i++){
      for(int y=1; y<splitList[i].length+1; y++){
        indexList.add(splitList[i].substring(0,y).toLowerCase());
      }
    }
    print(indexList);

    Firestore.instance.
    collection(collecion).document(doc).collection(subCol).document(id).updateData(
      {
        'searchIndex' : indexList
      }
    );

  }



}