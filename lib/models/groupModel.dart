import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  String id;
  String name;
  String leader;
  List<String> members;
  List<String> tokens;
  Timestamp groupCreated;
  String currentEventId;
  int indexPickingEvent;
  String nextEventId;
  Timestamp currentEventDue;
  Timestamp nextEventDue;

  GroupModel({
    this.id,
    this.name,
    this.leader,
    this.members,
    this.tokens,
    this.groupCreated,
    this.currentEventId,
    this.indexPickingEvent,
    this.nextEventId,
    this.currentEventDue,
    this.nextEventDue,
  });

  GroupModel.fromDocumentSnapshot({DocumentSnapshot doc}) {

    id = doc.documentID;
    name = doc.data["name"];
    leader = doc.data["leader"];
    members = List<String>.from(doc.data["members"]);
    tokens = List<String>.from(doc.data["tokens"] ?? []);
    groupCreated = doc.data["groupCreated"];
    currentEventId = doc.data["currentEventId"];
    indexPickingEvent = doc.data["indexPickingEvent"];
    nextEventId = doc.data["nextEventId"];
    currentEventDue = doc.data["currentEventDue"];
    nextEventDue = doc.data["nextEventDue"];
  }
}