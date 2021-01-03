import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String id;
  String authorId;
  String authorEmail;
  String priority;
  String contents;

  TaskModel({
    this.id,
    this.authorEmail,
    this.authorId,
    this.priority,
    this.contents,
  });

  TaskModel.fromDocumentSnapshot({DocumentSnapshot doc}) {
    id = doc.documentID;
    authorEmail= doc.data["authorEmail"];
    authorId = doc.data["author"];
    contents = doc.data["contents"];
    priority = doc.data["priority"];
  }
}