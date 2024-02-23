import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCores {
  static getRecords(String id){
    {return FirebaseFirestore.instance
        .collection("students")
        .doc(id)
        .collection("Records")
        .snapshots();}
  }
}