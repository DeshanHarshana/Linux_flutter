import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService{
  searchByname(String searchField){
    return Firestore.instance.collection('clients')
    .where("searchKey",isEqualTo: searchField.substring(0,1).toUpperCase())
    .getDocuments();
  }
}