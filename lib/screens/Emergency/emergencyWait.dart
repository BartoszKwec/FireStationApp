// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fire_station_inz_app/models/EmergencyModel.dart';
// import 'package:fire_station_inz_app/models/authModel.dart';
// import 'package:fire_station_inz_app/models/groupModel.dart';
// import 'package:fire_station_inz_app/models/membersModel.dart';
// import 'package:fire_station_inz_app/models/userModel.dart';
// import 'package:fire_station_inz_app/screens/inGroup/taskList.dart';
// import 'package:fire_station_inz_app/screens/rank/rank.dart';
// import 'package:fire_station_inz_app/screens/root/root.dart';
// import 'package:fire_station_inz_app/screens/task/task.dart';
// import 'package:fire_station_inz_app/services/dbFuture.dart';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';


// DocumentSnapshot snapshot;
// class EmergencyAlertInfo1 extends StatefulWidget {

//  //final String userUid;
//   // final String taskUid;
//   final String groupId;
//   final String alertId;


//   EmergencyAlertInfo1({@required this.groupId, this.alertId});
//   @override
//   _EmergencyAlertInfoState1 createState() => _EmergencyAlertInfoState1();


// }

// class _EmergencyAlertInfoState1 extends State<EmergencyAlertInfo1> {
//   final emergencyKey = GlobalKey<ScaffoldState>();
//   TextEditingController _reviewController = TextEditingController();
//   String _dropdownValue;
//   AuthModel _authModel;

//   Future<EmergencyModel> _emergencyModel;
//   Future<EmergencyModel> getData()async{
//     return await DBFuture().getAlert1(widget.groupId, widget.alertId);
//   }

//   @override
//   void didChangeDependencies() {
//     _authModel = Provider.of<AuthModel>(context);
//     super.didChangeDependencies();
//     _emergencyModel=getData();
//     print(widget.groupId+"   "+widget.alertId);

//     print(_emergencyModel);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Color.fromARGB(255, 213, 84, 75),
//         title: Text(
//           "aaaa",style: new TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 25.0,

//         )
//         ),
//         // leading: BackButton(
//         //     color: Colors.black
//         // ),
//         leading: new IconButton(
//           icon: new Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.push(context,MaterialPageRoute(
//             builder: (context)=>OurRoot()
//           )
//           ),
//         ),

//       ),
//     body: FutureBuilder<List<EmergencyModel>>(
//       future: _emergencyModel,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {

//           return ListView.builder(
//             itemCount: snapshot.data.length,
//             shrinkWrap: true,

//             itemBuilder: (BuildContext context, index) =>
//                 Container(

//                   width: MediaQuery
//                       .of(context)
//                       .size
//                       .width,
//                   padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
//                   child: Card(
//                     elevation: 10.0,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(25.0),
//                     ),
//                     child: Container(

//                       width: MediaQuery
//                           .of(context)
//                           .size
//                           .width,
//                       padding: EdgeInsets.symmetric(
//                           horizontal: 5.0, vertical: 10.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: <Widget>[

//                               SizedBox(
//                                 width: 5.0,
//                               ),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: <Widget>[
//                                   Text("Email: "+snapshot.data[index].email, style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
//                                   Text("Nazwa: "+snapshot.data[index].fullName,
//                                       style: new TextStyle(fontWeight: FontWeight.normal, fontSize: 20.0)),
//                                   Text((snapshot.data[index].rank=="" ||snapshot.data[index].rank==null)?("Ranga: brak rangi"):("Ranga: "+snapshot.data[index].rank)),
//                                   Container(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: 10, vertical: 5.0),
//                                     alignment: Alignment.center,
//                                     child: Row(
//                                       children: <Widget>[
                                        
                                        
                                       
//                                       ],
//                                     ),
//                                   ),

//                                 ],
//                               ),


//                             ],

//                           ),

//                         ],
//                       ),

//                     ),

                    

//                   ),
                  

//                 ),
//           );
//         }
//         return Center(child: CircularProgressIndicator(

//         ),
//         );
//       },
//     )
//     );


//   }

// }

