
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_station_inz_app/models/groupModel.dart';
import 'package:fire_station_inz_app/models/userModel.dart';

class DBStream {
  Firestore _firestore = Firestore.instance;

  Stream<UserModel> getCurrentUser(String uid) {

    return _firestore
        .collection('users')
        .document(uid)
        .snapshots()
        .map((docSnapshot) => UserModel.fromDocumentSnapshot(doc: docSnapshot));
  }

  Stream<GroupModel> getCurrentGroup(String groupId) {
    return _firestore
        .collection('groups')
        .document(groupId)
        .snapshots()
        .map((docSnapshot) => GroupModel.fromDocumentSnapshot(doc: docSnapshot));
  }
}