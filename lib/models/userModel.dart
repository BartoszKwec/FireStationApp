import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String email;
  Timestamp accountCreated;
  String fullName;
  String groupId;
  String notifToken;
  var photoUrl;
  String rank;

  UserModel({
    this.uid,
    this.email,
    this.accountCreated,
    this.fullName,
    this.groupId,
    this.notifToken,
    this.photoUrl,
    this.rank,
  });

  UserModel.fromDocumentSnapshot({DocumentSnapshot doc}) {

    uid = doc.documentID;
    email = doc.data['email'];
    accountCreated = doc.data['accountCreated'];
    fullName = doc.data['fullName'];
    groupId = doc.data['groupId'];
    notifToken = doc.data['notifToken'];
    photoUrl=doc.data['photoUrl'];
    rank=doc.data["rank"];
  }
  String get getNot{
    return notifToken;
  }
  Map<String,dynamic> get map{
    return {
      "uid": uid,
      "email": email,
    "fullName": fullName,
    "groupId": groupId,
    "notifToken": notifToken,
    };
  }
}