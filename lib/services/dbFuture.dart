
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
        'nextBookId': "waiting",
        'indexPickingBook': 0
      });
    } else {
      _docRef = await _firestore.collection("groups").add({
        'name': groupName.trim(),
        'leader': user2.uid,
        'members': members,
        'groupCreated': Timestamp.now(),
        'nextBookId': "waiting",
        'indexPickingBook': 0
      });
    }


    await _firestore.collection("users").document(user2.uid).updateData({

      'groupId': _docRef.documentID,
    });
    addBookEmpty(_docRef.documentID);
    retVal = "success";
  } catch (e) {
    print(e);
  }

  return retVal;

}


  Future<String> createGroup(
      //FirebaseUser user
      String groupName, FirebaseUser user, BookModel initialBook) async {
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
          'nextBookId': "waiting",
          'indexPickingBook': 0
        });
      } else {
        _docRef = await _firestore.collection("groups").add({
          'name': groupName.trim(),
          'leader': user.uid,
          'members': members,
          'groupCreated': Timestamp.now(),
          'nextBookId': "waiting",
          'indexPickingBook': 0
        });
      }


      await _firestore.collection("users").document(user.uid).updateData({

        'groupId': _docRef.documentID,
      });

      //add a book

      addBook(_docRef.documentID, initialBook);

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

  Future<String> addBook(String groupId, BookModel book) async {
    String retVal = "error";

    try {
      DocumentReference _docRef = await _firestore
          .collection("groups")

          .document(groupId)
          .collection("books")
          .add({
        'name': book.name.trim(),
        'author': book.author.trim(),
        'length': book.length,
        'dateCompleted': book.dateCompleted,
      });

      //add current book to group schedule

      await _firestore.collection("groups").document(groupId).updateData({

        "currentBookId": _docRef.documentID,
        "currentBookDue": book.dateCompleted,
      });

      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }
  Future<String> addBookEmpty(String groupId) async {
    String retVal = "error";

    try {
      DocumentReference _docRef = await _firestore
          .collection("groups")

          .document(groupId)
          .collection("books")
          .add({
        'name': "...",
        'author': "...",
        'length': "111",
        'dateCompleted': null,
      });

      //add current book to group schedule

      await _firestore.collection("groups").document(groupId).updateData({

        "currentBookId": null,
        "currentBookDue": null,
      });

      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> addNextBook(String groupId, BookModel book) async {
    String retVal = "error";

    try {
      DocumentReference _docRef = await _firestore
          .collection("groups")

          .document(groupId)
          .collection("books")
          .add({
        'name': book.name.trim(),
        'author': book.author.trim(),
        'length': book.length,
        'dateCompleted': book.dateCompleted,
      });

      //add current book to group schedule

      await _firestore.collection("groups").document(groupId).updateData({

        "nextBookId": _docRef.documentID,
        "nextBookDue": book.dateCompleted,
      });

      //adding a notification document
      DocumentSnapshot doc =
      await _firestore.collection("groups").document(groupId).get();
      createNotifications(
          List<String>.from(doc.data["tokens"]) ?? [], book.name, book.author);

      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> addCurrentBook(String groupId, BookModel book) async {
    String retVal = "error";

    try {
      DocumentReference _docRef = await _firestore
          .collection("groups")
          .document(groupId)
          .collection("books")
          .add({
        'name': book.name.trim(),
        'author': book.author.trim(),
        'length': book.length,
        'dateCompleted': book.dateCompleted,
      });


      await _firestore.collection("groups").document(groupId).updateData({
        "currentBookId": _docRef.documentID,
        "currentBookDue": book.dateCompleted,
      });

      //adding a notification document
      DocumentSnapshot doc =

      await _firestore.collection("groups").document(groupId).get();
      createNotifications(
          List<String>.from(doc.data["tokens"]) ?? [], book.name, book.author);

      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<BookModel> getCurrentBook(String groupId, String bookId) async {
    BookModel retVal;

    try {
      DocumentSnapshot _docSnapshot = await _firestore
          .collection("groups")
          .document(groupId)
          .collection("books")
          .document(bookId)
          .get();
      retVal = BookModel.fromDocumentSnapshot(doc: _docSnapshot);
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> finishedBook(
      String groupId,
      String bookId,
      String uid,
      int rating,
      String review,
      ) async {
    String retVal = "error";
    try {
      await _firestore
          .collection("groups")

          .document(groupId)
          .collection("books")

          .document(bookId)
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

  Future<bool> isUserDoneWithBook(
      String groupId, String bookId, String uid) async {
    bool retVal = false;
    try {
      DocumentSnapshot _docSnapshot = await _firestore
          .collection("groups")

          .document(groupId)
          .collection("books")

          .document(bookId)
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
      List<String> tokens, String bookName, String author) async {
    String retVal = "error";

    try {
      await _firestore.collection("notifications").add({
        'bookName': bookName.trim(),
        'author': author.trim(),
        'tokens': tokens,
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<List<BookModel>> getBookHistory(String groupId) async {
    List<BookModel> retVal = List();

    try {
      QuerySnapshot query = await _firestore
          .collection("groups")

          .document(groupId)
          .collection("books")
          .orderBy("dateCompleted", descending: true)

          .getDocuments();


      query.documents.forEach((element) {
        retVal.add(BookModel.fromDocumentSnapshot(doc: element));
      });
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<List<ReviewModel>> getReviewHistory(
      String groupId, String bookId) async {
    List<ReviewModel> retVal = List();

    try {
      QuerySnapshot query = await _firestore
          .collection("groups")

          .document(groupId)
          .collection("books")

          .document(bookId)
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