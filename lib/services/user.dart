// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:fire_station_inz_app/models/userModel.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // UserModel loggedInUser;
// //
// // saveUserInfoToFireStore() async {
// //   var user = FirebaseAuth.instance.currentUser();
// //   loggedInUser = user as UserModel;
// //   preferences = await SharedPreferences.getInstance();
// //   DocumentSnapshot documentSnapshot = await usersReference.document(
// //       loggedInUser.uid).get();
// // }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fire_station_inz_app/models/membersModel.dart';
// import 'package:fire_station_inz_app/models/userModel.dart';
// import 'package:fire_station_inz_app/services/dbFuture.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// Firestore _firestore = Firestore.instance;
// List<String> members = List();
//
// class UserList extends StatefulWidget {
//   final String groupId;
//
//   UserList({this.groupId});
//
//   @override
//   _UserListState createState() => _UserListState();
// }
//
// class _UserListState extends State<UserList> {
//   UserModel user;
//   Future<List<MembersModel>> members;
//   AsyncSnapshot<List<String>> snapshot;
//   @override
//   Future<void> didChangeDependencies() async {
//     super.didChangeDependencies();
//     members = DBFuture().getMembers(widget.groupId);
//     snapshot=members.toString() as AsyncSnapshot<List<String>>;
//     //user = await DBFuture().getUser(widget.userId);
//     setState(() {});
//
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       body: Container(
//         child: ListView.builder(
//           itemCount: snapshot.data.length,
//           shrinkWrap: true,
//           itemBuilder: (BuildContext context, int index) => Container(
//
//             width: MediaQuery.of(context).size.width,
//             padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
//             child: Card(
//               elevation: 10.0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(25.0),
//               ),
//               child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: <Widget>[
//                         // Container(
//                         //   width: 55.0,
//                         //   height: 55.0,
//                         //   child: CircleAvatar(
//                         //     //backgroundImage: users[index].photoUrl,
//                         //     backgroundColor: Colors.red,
//                         //   ),
//                         // ),
//                         SizedBox(
//                           width: 5.0,
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             Text(users[index].fullName,style: new TextStyle(fontWeight: FontWeight.bold, fontSize:25.0) ),
//                             Text("Ranga: "),
//                           ],
//                         ),
//                         Container(
//                           alignment: Alignment.centerRight,
//
//                           child: IconButton(
//
//                               onPressed: () {},
//                               color: Colors.blue,
//                               icon: Icon(Icons.person)
//                           ),
//
//                         ),
//                         Container(
//                           alignment: Alignment.centerRight,
//
//                           child: IconButton(
//
//                               onPressed: () {},
//                               color: Colors.red,
//                               icon: Icon(Icons.event_note)
//                           ),
//                         ),
//                         Container(
//                           alignment: Alignment.centerRight,
//
//                           child: IconButton(
//
//                               onPressed: () {},
//                               color: Colors.yellow,
//                               icon: Icon(Icons.email)
//                           ),
//                         ),
//
//
//                       ],
//                     ),
//
//                     // Container(
//                     //   alignment: Alignment.center,
//                     //   padding: EdgeInsets.symmetric(
//                     //       horizontal: 5.0, vertical: 5.0),
//                     //   child: IconButton(
//                     //
//                     //       onPressed: () {},
//                     //       color: Colors.blue,
//                     //       icon: Icon(Icons.person)
//                     //   ),
//                     // ),
//                     // Container(
//                     //   alignment: Alignment.center,
//                     //   padding: EdgeInsets.symmetric(
//                     //       horizontal: 5.0, vertical: 5.0),
//                     //   child: IconButton(
//                     //
//                     //       onPressed: () {},
//                     //       color: Colors.red,
//                     //       icon: Icon(Icons.email)
//                     //   ),
//                     // ),
//                     // Container(
//                     //   alignment: Alignment.center,
//                     //   padding: EdgeInsets.symmetric(
//                     //       horizontal: 5.0, vertical: 5.0),
//                     //   child: IconButton(
//                     //
//                     //       onPressed: () {},
//                     //       color: Colors.yellow,
//                     //       icon: Icon(Icons.smartphone)
//                     //   ),
//                     // ),
//                     // Container(
//                     //   alignment: Alignment.center,
//                     //   padding: EdgeInsets.symmetric(
//                     //       horizontal: 5.0, vertical: 5.0),
//                     //   child: IconButton(
//                     //
//                     //       onPressed: () {},
//                     //       color: Colors.green,
//                     //       icon: Icon(Icons.event)
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
