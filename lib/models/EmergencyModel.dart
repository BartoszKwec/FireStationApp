import 'package:cloud_firestore/cloud_firestore.dart';

class EmergencyModel {
  String id;
  String place;
  String description;
  String injured;
  Timestamp dateCreated;
  String author;

  EmergencyModel({
    this.id,
    this.place,
    this.description,
    this.injured,
    this.dateCreated,
    this.author,
  });

  EmergencyModel.fromDocumentSnapshot({DocumentSnapshot doc}) {

    id = doc.documentID;
    place = doc.data["name"];
    description = doc.data["author"];
    injured = doc.data["injured"];
    dateCreated = doc.data['dateCreated'];
    author= doc.data['author'];
  }
}