
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_station_inz_app/models/EmergencyModel.dart';
import 'package:fire_station_inz_app/models/eventModel.dart';
import 'package:fire_station_inz_app/models/groupModel.dart';
import 'package:fire_station_inz_app/models/membersModel.dart';
import 'package:fire_station_inz_app/models/reviewModel.dart';
import 'package:fire_station_inz_app/models/taskModel.dart';
import 'package:fire_station_inz_app/models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

  Future<DocumentSnapshot> getData() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser;
    return _firestore.collection("users").document(user.uid).get();
  }
  

  Future<String> createGroupBase(String groupName, FirebaseUser user) async {
    String retVal = "error";
    List<String> members = List();
    List<String> tokens = List();

    try {
      members.add(user.uid);
      // tokens.add(user.notifToken);
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
      addEventEmpty(_docRef.documentID);
      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> createGroup(

      //FirebaseUser user
      String groupName,
      UserModel userModel,
      EventModel initialEvent) async {
    //FirebaseUser user,
    // user.uid = "1bO6JCkcGvfDZwVnWctFxhhiw163";
    print("jestem tutaj");
    print(userModel.uid);
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
      members.add(userModel.uid);
      tokens.add(userModel.notifToken);
      DocumentReference _docRef;
      if (userModel.notifToken != null) {
        _docRef = await _firestore.collection("groups").add({
          'name': groupName, //tu i w else .trim()
          'leader': userModel.uid,
          'members': members,
          'tokens': tokens,
          'groupCreated': Timestamp.now(),
          'nextEventId': "waiting",
          'indexPickingEvent': 0,
          'duringEmergency': false,
        });
      } else {
        _docRef = await _firestore.collection("groups").add({
          'name': groupName,
          'leader': userModel.uid,
          'members': members,
          'groupCreated': Timestamp.now(),
          'nextEventId': "waiting",
          'indexPickingEvent': 0,
          'duringEmergency': false,
        });
      }

      await _firestore.collection("users").document(userModel.uid).updateData({
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
      createNotifications(List<String>.from(doc.data["tokens"]) ?? [],
          event.name, event.author);

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
      createNotifications(List<String>.from(doc.data["tokens"]) ?? [],
          event.name, event.author);

      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> addRank(String uid, String rank) async {
    String retVal = "error";

    try {
      await _firestore.collection("users").document(uid).updateData({
        'rank': rank,
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> addTask(
      String uid, String contents, String priority, String authorEmail) async {
    String retVal = "error";

    try {
      DocumentReference _docRef = await _firestore
          .collection("users")
          .document(uid)
          .collection("tasks")
          .add({
        'userUid': uid,
        'authorEmail': authorEmail,
        'priority': priority,
        'contents': contents,
      });

      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }
  Future<String>createEmergencyHistory(
      String groupId, EmergencyModel emergencyModel, String author)async{
        String retVal = "error";
        try{
          DocumentReference _docRef = await _firestore
          .collection("groups")
          .document(groupId)
          .collection("emergenciesHistory")
          .add({
         
        'place': emergencyModel.place,
        'description': emergencyModel.description,
        'injured': emergencyModel.injured,
        'author': author,
        'duringEmergency': emergencyModel.view,
        //'dataCreated': emergencyModel.dateCreated,

        
      });
        }catch (e) {
      print(e);
    }

    return retVal;
  }
  void deleteEmergencyAlert(String groupUid) async {

    try {
      // await _firestore
      //     .collection("groups")
      //     .document(groupUid)
      //     .collection("emergencies")
          
      //     .delete();

      await _firestore.collection('groups').document(groupUid).collection("emergencies").getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents){
        ds.reference.delete();
      };
    });

        
       await _firestore.collection("groups").document(groupUid).updateData({
        "duringEmergency": false,

        
      });


    } catch (e) {
      print(e);
    }
  }
  Future<String> emergencyAccept(String groupId, String emeId)async {
    //String place, String description, String injured
    String retVal = "error";
    //DocumentReference _docRef;
    
    
    try {
      await _firestore
          .collection("groups")
          .document(groupId)
          .collection("emergencies")
          .document(emeId)
          .updateData({
            "accept": FieldValue.increment(1),
         
      });
             
      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }
  Future<String> emergencyReject(String groupId, String emeId)async {
    //String place, String description, String injured
    String retVal = "error";
    //DocumentReference _docRef;
    
    
    try {
      await _firestore
          .collection("groups")
          .document(groupId)
          .collection("emergencies")
          .document(emeId)
          .updateData({
            "noAccept": FieldValue.increment(1),
         
      });
             
      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> createEmergency(
      String groupId, EmergencyModel emergencyModel, String author) async {
    //String place, String description, String injured
    String retVal = "error";
    //DocumentReference _docRef;
    
    
      // await _firestore.collection("groups").document(groupId).updateData({
      //   'members': FieldValue.arrayUnion(members),
      //   'tokens': FieldValue.arrayUnion(tokens),
    
  
    try {
      DocumentReference _docRef = await _firestore
          .collection("groups")
          .document(groupId)
          .collection("emergencies")
          .add({
         
        'place': emergencyModel.place,
        'description': emergencyModel.description,
        'injured': emergencyModel.injured,
        'author': author,
        'duringEmergency': emergencyModel.view,
        'accept' : 0,
        'noAccept': 0,
        
        //'dataCreated': emergencyModel.dateCreated,
        
        
      });
      await _firestore.collection("groups").document(groupId).updateData({
        "duringEmergency": emergencyModel.view,
        "alertsId": _docRef.documentID,
      });
     
      DocumentSnapshot doc =
          await _firestore.collection("groups").document(groupId).get();
      createNotificationsEmergency(
          List<String>.from(doc.data["tokens"]) ?? [],
          emergencyModel.description,
          emergencyModel.place,
          emergencyModel.injured,
          author);
      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> createNotificationsEmergency(List<String> tokens,
      String description, String place, String injured, String author) async {
    String retVal = "error";

    try {
      await _firestore.collection("emergencies").add({
        'description': description,
        'place': place,
        'injured': injured,
        'tokens': tokens,
        'author': author,
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  void deleteTask(String userUid, String taskUid) async {
    try {
      await _firestore
          .collection("users")
          .document(userUid)
          .collection("tasks")
          .document(taskUid)
          .delete();
    } catch (e) {
      print(e);
    }
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

  Future<TaskModel> getTask(String userId, String taskId) async {
    TaskModel taskModel;

    try {
      DocumentSnapshot _docSnapshot = await _firestore
          .collection("users")
          .document(userId)
          .collection("tasks")
          .document(taskId)
          .get();
      taskModel = TaskModel.fromDocumentSnapshot(doc: _docSnapshot);
    } catch (e) {
      print(e);
    }

    return taskModel;
  }
  Future<List<EmergencyModel>> getAlert(String groupId) async {
    List<EmergencyModel> emergencyModel = List();

    try {
      QuerySnapshot query = await _firestore
          .collection("groups")
          .document(groupId)
          .collection("emergencies")
          .getDocuments();

      query.documents.forEach((element) {
        emergencyModel.add(EmergencyModel.fromDocumentSnapshot(doc: element));
      });
    } catch (e) {
      print(e);
    }

    return emergencyModel;
  }
Future<EmergencyModel> getAlert1(String groupId, String alertId) async {
    EmergencyModel emergencyModel;

    try {
      DocumentSnapshot _docSnapshot = await _firestore
          .collection("groups")
          .document(groupId)
          .collection("emergencies")
          .document(alertId).get();


        emergencyModel=(EmergencyModel.fromDocumentSnapshot(doc: _docSnapshot));

    } catch (e) {
      print(e);
    }
    

    return emergencyModel;
  }
  // Future<List<EmergencyModel>>getAlerts(List<String> id)async{
  //     List<EmergencyModel> retVal = [];
  //     for(var uid in id){
  //       retVal.add(await getAlert1(uid));
  //     }
  //     return retVal;
  //   }
  // Future<TaskModel> getTaskId(String userId) async{
  //   TaskModel taskModel;
  //
  //   try {
  //     DocumentSnapshot _docSnapshot =
  //     await _firestore.collection("users").document(userId).collection("tasks").document().get();
  //     taskModel = TaskModel.fromDocumentSnapshot(doc: _docSnapshot);
  //   } catch (e) {
  //     print(e);
  //   }
  //
  //   return taskModel;
  //
  // }
  // Future<List> getTasks(String userId) async{
  //   List<TaskModel> taskList = [];
  //
  //   // QuerySnapshot querySnapshot = await Firestore.instance.collection("users").document(userId).collection("tasks").getDocuments();
  //   // taskList = querySnapshot.documents.cast<TaskModel>();
  //
  //
  //
  //   try {
  //     DocumentSnapshot _docSnapshot =
  //     await _firestore.collection("users").document(userId).collection("tasks").document().get();
  //     //taskList = TaskModel.fromDocumentSnapshot(doc: _docSnapshot);
  //   } catch (e) {
  //     print(e);
  //   }
  //
  //
  //
  //   return taskList;
  //
  // }

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
        'uid': user.uid,
        'photoUrl': user.photoUrl,
        'rank': user.rank,
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
  Future<UserModel> getAlertId(String alertId, String groupId) async {
    UserModel retVal;

    try {
      DocumentSnapshot _docSnapshot =
          await _firestore.collection("group").document(groupId).
          collection("emergencies").document(alertId).
          get();
      retVal = UserModel.fromDocumentSnapshot(doc: _docSnapshot);
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  // Future<List<UserModel>> getUserList(List<String>members)async{
  //   List<UserModel> retVal;
  //   int index=0;
  //   String uid;
  //   for (var id in members) retVal.add(await getUser(uid));
  //     uid=members[index];
  //
  //     retVal=getUser(uid) as List<UserModel>;
  //     index++;
  //
  //   return retVal;
  // }
  Future<List<UserModel>> getUsers(List<String> members) async {
    List<UserModel> retVal = [];
    for (var uid in members) {
      retVal.add(await getUser(uid));
    }
    return retVal;
  }

  Future<List<MembersModel>> getMembers(String groupId) async {
    List<MembersModel> retVal = List();

    try {
      QuerySnapshot query = await _firestore
          .collection("groups")
          .document(groupId)
          .collection("members")
          .getDocuments();

      query.documents.forEach((element) {
        retVal.add(MembersModel.fromDocumentSnapshot(doc: element));
      });
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<List<TaskModel>> getTasks(String userId) async {
    List<TaskModel> retVal = List();

    try {
      QuerySnapshot query = await _firestore
          .collection("users")
          .document(userId)
          .collection("tasks")
          .getDocuments();

      query.documents.forEach((element) {
        retVal.add(TaskModel.fromDocumentSnapshot(doc: element));
      });
    } catch (e) {
      print(e);
    }

    return retVal;
  }
  Future<List<EmergencyModel>> getAlertsHistory(String groupId) async {
    List<EmergencyModel> retVal = List();

    try {
      QuerySnapshot query = await _firestore
          .collection("groups")
          .document(groupId)
          .collection("emergenciesHistory")
          .getDocuments();

      query.documents.forEach((element) {
        retVal.add(EmergencyModel.fromDocumentSnapshot(doc: element));
      });
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<GroupModel> getGroup(String groupId) async {
    GroupModel retVal;

    try {
      DocumentSnapshot _docSnapshot =
          await _firestore.collection("groups").document(groupId).get();
      retVal = GroupModel.fromDocumentSnapshot(doc: _docSnapshot);
    } catch (e) {
      print(e);
    }

    return retVal;
  }
  

  // Future<List<GroupModel>> getGroup2(String groupId)async{
  //   List<GroupModel> retVal = List();
  //
  //   try {
  //     DocumentSnapshot _docSnapshot =  (await _firestore
  //         .collection("groups")
  //
  //         .document(groupId)
  //
  //         .get());
  //
  //
  //   //retVal = GroupModel.fromDocumentSnapshot(doc: _docSnapshot);
  //   } catch (e) {
  //   print(e);
  //   }
  //   return retVal;
  // }
  // Future<List<String>> getMembersId(String groupId)async{
  //   List<String> retVal = List();
  //
  //   try {
  //     QuerySnapshot query = await _firestore
  //         .collection("groups")
  //         .document(groupId)
  //         .collection("members")
  //         .getDocuments();
  //
  //     query.documents.forEach((element) {
  //       retVal.add(List<String>.fromDocumentSnapshot(doc: element));
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  //
  //   return retVal;
  // }
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

// Future<List<MembersModel>> getMembers5(String groupId)async {
//   List<MembersModel> retVal = List();
//
//   try {
//     QuerySnapshot query = await _firestore
//         .collection("groups")
//         .document(groupId)
//         .getDocuments();
//
//     query.documents.forEach((element) {
//       retVal.add(MembersModel.fromDocumentSnapshot(doc: element));
//     });
//   } catch (e) {
//     print(e);
//   }
//
//   return retVal;
// }
  Future<void> saveTokenToDatabase(String token) async {
    // Assume user is logged in for this example

    final FirebaseUser userr = await auth.currentUser();
    String userId = userr.uid;
    await _firestore.collection('users').document(userId).updateData({
      'tokens': FieldValue.arrayUnion([token]),
    });
  }

}
