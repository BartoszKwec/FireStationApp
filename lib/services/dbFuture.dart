
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_station_inz_app/models/eventModel.dart';
import 'package:fire_station_inz_app/models/reviewModel.dart';
import 'package:fire_station_inz_app/models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DBFuture {
  // final FirebaseAuth auth1 = FirebaseAuth.instance;
  FirebaseUser user1;
  FirebaseAuth auth;
  Firestore _firestore = Firestore.instance;
  UserModel loggedInUser;



  FirebaseUser user;

  void inputData() async {
    final FirebaseUser userr = await auth.currentUser();
    final uuid = userr.uid;

  }

  Future<DocumentSnapshot> getData() async{
    var firebaseUser = await FirebaseAuth.instance.currentUser;
    return _firestore.collection("users").document(user.uid).get();

  }

Future<String> createGroupBase(String groupName, FirebaseUser user2)async{
  String retVal = "error";
  List<String> members = List();
  List<String> tokens = List();

  try {
    members.add(user2.uid);
    //tokens.add(user.notifToken);
    DocumentReference _docRef;
    if (user != null) {
      _docRef = await _firestore.collection("groups").add({
        'name': groupName.trim(),
        'leader': user2.uid,
        'members': members,
        'tokens': tokens,
        'groupCreated': Timestamp.now(),
        'nextEventId': "waiting",
        'indexPickingEvent': 0
      });
    } else {
      _docRef = await _firestore.collection("groups").add({
        'name': groupName.trim(),
        'leader': user2.uid,
        'members': members,
        'groupCreated': Timestamp.now(),
        'nextEventId': "waiting",
        'indexPickingEvent': 0
      });
    }


    await _firestore.collection("users").document(user2.uid).updateData({

      'groupId': _docRef.documentID,
    });
    addEventEmpty(_docRef.documentID);
    retVal = "success";
  } catch (e) {
    print(e);
  }

  return retVal;

}


  Future<String> createGroup(
      //FirebaseUser user
      String groupName, FirebaseUser user, EventModel initialEvent) async {
    // user.uid = "1bO6JCkcGvfDZwVnWctFxhhiw163";

    //print(user.uid);
    String retVal = "error";
    List<String> members = List();
    List<String> tokens = List();

    //Future <UserModel> vall=getUser(user.uid);



    // user.uid= (await _firestore.collection("users").document(user.uid).get()) as String;
    //user.notifToken= (await _firestore.collection("user").document(user.notifToken).get()) as String;
    //var userfullName= (await _firestore.collection("users").document(user.notifToken).get()) as String;
    // user.email= (await _firestore.collection("user").document(user.email).get()) as String;
    // user.groupId= (await _firestore.collection("user").document(user.groupId).get()) as String;
    // final FirebaseUser userr = await auth.currentUser();
    // final uuid = userr.uid;
    // print("db db db db");
    // print(uuid);

    try {
      members.add(user.uid);
      //tokens.add(userModel.notifToken);
      DocumentReference _docRef;
      if (user != null) {
        _docRef = await _firestore.collection("groups").add({
          'name': groupName.trim(),
          'leader': user.uid,
          'members': members,
          'tokens': tokens,
          'groupCreated': Timestamp.now(),
          'nextEventId': "waiting",
          'indexPickingEvent': 0
        });
      } else {
        _docRef = await _firestore.collection("groups").add({
          'name': groupName.trim(),
          'leader': user.uid,
          'members': members,
          'groupCreated': Timestamp.now(),
          'nextEventId': "waiting",
          'indexPickingEvent': 0
        });
      }


      await _firestore.collection("users").document(user.uid).updateData({

        'groupId': _docRef.documentID,
      });

      //add a event

      addEvent(_docRef.documentID, initialEvent);

      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> joinGroup(String groupId, UserModel userModel) async {
    String retVal = "error";
    List<String> members = List();
    List<String> tokens = List();
    try {
      members.add(userModel.uid);
      tokens.add(userModel.notifToken);

      await _firestore.collection("groups").document(groupId).updateData({
        'members': FieldValue.arrayUnion(members),
        'tokens': FieldValue.arrayUnion(tokens),
      });


      await _firestore.collection("users").document(userModel.uid).updateData({
        'groupId': groupId.trim(),
      });

      retVal = "success";
    } on PlatformException catch (e) {
      retVal = "Make sure you have the right group ID!";
      print(e);
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> leaveGroup(String groupId, UserModel userModel) async {
    String retVal = "error";
    List<String> members = List();
    List<String> tokens = List();
    try {
      members.add(userModel.uid);
      tokens.add(userModel.notifToken);

      await _firestore.collection("groups").document(groupId).updateData({
        'members': FieldValue.arrayRemove(members),
        'tokens': FieldValue.arrayRemove(tokens),
      });


      await _firestore.collection("users").document(userModel.uid).updateData({
        'groupId': null,
      });
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> addEvent(String groupId, EventModel event) async {
    String retVal = "error";

    try {
      DocumentReference _docRef = await _firestore
          .collection("groups")

          .document(groupId)
          .collection("events")
          .add({
        'name': event.name.trim(),
        'author': event.author.trim(),
        'length': event.length,
        'dateCompleted': event.dateCompleted,
      });

      //add current event to group schedule

      await _firestore.collection("groups").document(groupId).updateData({

        "currentEventId": _docRef.documentID,
        "currentEventDue": event.dateCompleted,
      });

      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }
  Future<String> addEventEmpty(String groupId) async {
    String retVal = "error";

    try {
      DocumentReference _docRef = await _firestore
          .collection("groups")

          .document(groupId)
          .collection("events")
          .add({
        'name': "...",
        'author': "...",
        'length': "111",
        'dateCompleted': null,
      });

      //add current event to group schedule

      await _firestore.collection("groups").document(groupId).updateData({

        "currentEventId": null,
        "currentEventDue": null,
      });

      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> addNextEvent(String groupId, EventModel event) async {
    String retVal = "error";

    try {
      DocumentReference _docRef = await _firestore
          .collection("groups")

          .document(groupId)
          .collection("events")
          .add({
        'name': event.name.trim(),
        'author': event.author.trim(),
        'length': event.length,
        'dateCompleted': event.dateCompleted,
      });

      //add current event to group schedule

      await _firestore.collection("groups").document(groupId).updateData({

        "nextEventId": _docRef.documentID,
        "nextEventDue": event.dateCompleted,
      });

      //adding a notification document
      DocumentSnapshot doc =
      await _firestore.collection("groups").document(groupId).get();
      createNotifications(
          List<String>.from(doc.data["tokens"]) ?? [], event.name, event.author);

      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> addCurrentEvent(String groupId, EventModel event) async {
    String retVal = "error";

    try {
      DocumentReference _docRef = await _firestore
          .collection("groups")
          .document(groupId)
          .collection("events")
          .add({
        'name': event.name.trim(),
        'author': event.author.trim(),
        'length': event.length,
        'dateCompleted': event.dateCompleted,
      });


      await _firestore.collection("groups").document(groupId).updateData({
        "currentEventId": _docRef.documentID,
        "currentEventDue": event.dateCompleted,
      });

      //adding a notification document
      DocumentSnapshot doc =

      await _firestore.collection("groups").document(groupId).get();
      createNotifications(
          List<String>.from(doc.data["tokens"]) ?? [], event.name, event.author);

      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<EventModel> getCurrentEvent(String groupId, String eventId) async {
    EventModel retVal;

    try {
      DocumentSnapshot _docSnapshot = await _firestore
          .collection("groups")
          .document(groupId)
          .collection("events")
          .document(eventId)
          .get();
      retVal = EventModel.fromDocumentSnapshot(doc: _docSnapshot);
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> finishedEvent(
      String groupId,
      String eventId,
      String uid,
      int rating,
      String review,
      ) async {
    String retVal = "error";
    try {
      await _firestore
          .collection("groups")

          .document(groupId)
          .collection("events")

          .document(eventId)
          .collection("reviews")

          .document(uid)

          .setData({
        'rating': rating,
        'review': review,
      });
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<bool> isUserDoneWithEvent(
      String groupId, String eventId, String uid) async {
    bool retVal = false;
    try {
      DocumentSnapshot _docSnapshot = await _firestore
          .collection("groups")

          .document(groupId)
          .collection("events")

          .document(eventId)
          .collection("reviews")

          .document(uid)
          .get();

      if (_docSnapshot.exists) {
        retVal = true;
      }
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> createUser(UserModel user) async {
    String retVal = "error";

    try {

      await _firestore.collection("users").document(user.uid).setData({
        'fullName': user.fullName.trim(),
        'email': user.email.trim(),
        'accountCreated': Timestamp.now(),
        'notifToken': user.notifToken,
        'uid' : user.uid,
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }


  Future<UserModel> getUser(String uid) async {
    UserModel retVal;

    try {
      DocumentSnapshot _docSnapshot =
      await _firestore.collection("users").document(uid).get();
      retVal = UserModel.fromDocumentSnapshot(doc: _docSnapshot);
    } catch (e) {
      print(e);
    }

    return retVal;
  }
  // //
  // Future <UserModel> getUserInfo(String uid) async{
  //   UserModel retVal = UserModel();
  //   try{
  //     DocumentSnapshot _docSnapshot = await _firestore.collection("users").document(uid).get();
  //     retVal.uid=uid;
  //     retVal.fullName=_docSnapshot.data["fullName"];
  //     retVal.email=_docSnapshot.data["email"];
  //     retVal.accountCreated=_docSnapshot.data["accountCreated"];
  //     retVal.groupId= _docSnapshot.data["groupId"];
  //   }catch(e){
  //     print(e);
  //   }
  //   return retVal;
  // }
  // saveUserInfoToFireStore() async {
  //   currentUser = UserModel(); //initialize
  //   preferences = await SharedPreferences.getInstance();
  //   DocumentSnapshot documentSnapshot = await usersReference.document(
  //       currentUser.id).get();
  // }
  Future<String> createNotifications(
      List<String> tokens, String eventName, String author) async {
    String retVal = "error";

    try {
      await _firestore.collection("notifications").add({
        'eventName': eventName.trim(),
        'author': author.trim(),
        'tokens': tokens,
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<List<EventModel>> getEventHistory(String groupId) async {
    List<EventModel> retVal = List();

    try {
      QuerySnapshot query = await _firestore
          .collection("groups")

          .document(groupId)
          .collection("events")
          .orderBy("dateCompleted", descending: true)

          .getDocuments();


      query.documents.forEach((element) {
        retVal.add(EventModel.fromDocumentSnapshot(doc: element));
      });
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<List<ReviewModel>> getReviewHistory(
      String groupId, String eventId) async {
    List<ReviewModel> retVal = List();

    try {
      QuerySnapshot query = await _firestore
          .collection("groups")

          .document(groupId)
          .collection("events")

          .document(eventId)
          .collection("reviews")

          .getDocuments();


      query.documents.forEach((element) {
        retVal.add(ReviewModel.fromDocumentSnapshot(doc: element));
      });
    } catch (e) {
      print(e);
    }
    return retVal;
  }

}