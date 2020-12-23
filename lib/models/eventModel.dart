import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String id;
  String name;
  String author;
  int length;
  Timestamp dateCompleted;

  EventModel({
    this.id,
    this.name,
    this.length,
    this.dateCompleted,
  });

  EventModel.fromDocumentSnapshot({DocumentSnapshot doc}) {

    id = doc.documentID;
    name = doc.data["name"];
    author = doc.data["author"];
    length = doc.data["length"];
    dateCompleted = doc.data['dateCompleted'];
  }
}