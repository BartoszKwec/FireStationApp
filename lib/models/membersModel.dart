import 'package:cloud_firestore/cloud_firestore.dart';

class MembersModel {
  String userId;
  //List<String> members;
  //String name;
 // String email;

  MembersModel({
    this.userId,
    //this.members,
    //this.name,
   // this.email,
  });

  MembersModel.fromDocumentSnapshot({DocumentSnapshot doc}) {

    userId = doc.documentID;
    //members = List<String>.from(doc.data["members"]);
    //name = doc.data["fullName"];
    //email = doc.data["email"];
  }
}