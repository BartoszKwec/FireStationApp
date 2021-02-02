import 'package:cloud_firestore/cloud_firestore.dart';

class EmergencyModel {
  String id;
  String place;
  String description;
  String injured;
  //Timestamp dateCreated;
  String author;
  bool view;
  int accept;
  int noAccept;
  
  // Map<String,String> infoMembers;
  // List<String> membersYes;
  // List<String> membersNo;
  // List<String> timeYes;
  // List<String> timeNo;

  EmergencyModel({
    this.id,
    this.place,
    this.description,
    this.injured,
    //this.dateCreated,
    this.author,
    this.view,
    this.accept,
    this.noAccept,
    // this.infoMembers,
    // this.membersYes,
    // this.membersNo,
    // this.timeYes,
    // this.timeNo,
  });

  EmergencyModel.fromDocumentSnapshot({DocumentSnapshot doc}) {

    id = doc.documentID;
    place = doc.data["place"];
    description = doc.data["description"];
    injured = doc.data["injured"];
    //dateCreated = doc.data['dateCreated'];
    author= doc.data['author'];
    view= doc.data['view'];
    accept = doc.data['accept'];
    noAccept = doc.data['noAccept'];
    // infoMembers = Map<String,String>.from(doc.data["infoMembers"]);
    // membersYes= List<String>.from(doc.data["membersYes"]);
    // membersNo= List<String>.from(doc.data["membersNo"]);
    // timeYes= List<String>.from(doc.data["timeYes"]);
    // timeNo= List<String>.from(doc.data["timeNo"]);

  }
}