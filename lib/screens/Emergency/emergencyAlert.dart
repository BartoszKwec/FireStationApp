import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_station_inz_app/models/EmergencyModel.dart';
import 'package:fire_station_inz_app/models/authModel.dart';
import 'package:fire_station_inz_app/models/emergencyDuringModel.dart';
import 'package:fire_station_inz_app/models/groupModel.dart';
import 'package:fire_station_inz_app/models/taskModel.dart';
import 'package:fire_station_inz_app/models/userModel.dart';
import 'package:fire_station_inz_app/screens/inGroup/inGroup.dart';
import 'package:fire_station_inz_app/screens/inGroup/taskList.dart';
import 'package:fire_station_inz_app/screens/inGroup/userList.dart';
import 'package:fire_station_inz_app/screens/root/root.dart';
import 'package:fire_station_inz_app/services/dbFuture.dart';
import 'package:fire_station_inz_app/widgets/shadowContainer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
DocumentSnapshot snapshot;
class EmergencyAlert extends StatefulWidget {

 //final String userUid;
  // final String taskUid;
  final String groupId;
  final String alertId;
  final String userName;

  EmergencyAlert({@required this.groupId, this.alertId, this.userName});
  @override
  _EmergencyAlertState createState() => _EmergencyAlertState();


}

class _EmergencyAlertState extends State<EmergencyAlert> {
  final emergencyKey = GlobalKey<ScaffoldState>();
  TextEditingController _reviewController = TextEditingController();
  String _dropdownValue;
  AuthModel _authModel;

  Future<EmergencyDuringModel> _emergencyModel;
  Future<EmergencyDuringModel> getData()async{
    return await DBFuture().getAlert1(widget.groupId, widget.alertId);
  }

  @override
  void didChangeDependencies() {
    _authModel = Provider.of<AuthModel>(context);
    super.didChangeDependencies();
    _emergencyModel=getData();
    print(widget.groupId+"   "+widget.alertId);

    print(_emergencyModel);
  }



  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 202, 17, 0),
          title: Text("Trwający alarm",
              style: new TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
              )),
          // leading: BackButton(
          //     color: Colors.black
          // ),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => OurRoot())),
          ),
        ),
     
      
      body: FutureBuilder<EmergencyDuringModel>(
        future: _emergencyModel, 
        builder: (BuildContext context, AsyncSnapshot<EmergencyDuringModel> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            
          ),
          //Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 50.0),
            child: ShadowContainer(
              child: Column(
                
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text("Alarm!", style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 35.0,
                      ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    


                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        (Text("Miejsce zdarzenia: ", textAlign: TextAlign.center,
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0))),
                        Container(
                          padding: EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                          width:
                          (MediaQuery
                              .of(context)
                              .size
                              .width) /
                              3,
                          child: Text(
                            snapshot.data.place,textAlign: TextAlign.center,
                            //overflow: TextOverflow.ellipsis,
                            maxLines: 10,
                          style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 15.0,
                        ),
                        ),
                        
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        (Text("Opis :",textAlign: TextAlign.center,
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0))),
                        Container(
                          padding: EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                          width:
                          (MediaQuery
                              .of(context)
                              .size
                              .width) /
                              1,
                          child: Text(
                            snapshot.data.description, textAlign: TextAlign.center,
                            //overflow: TextOverflow.ellipsis,
                            maxLines: 10,
                          style: TextStyle(
                            
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 15.0,
                        ),)
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        (Text("Liczba poszkodowanych :",textAlign: TextAlign.center,
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0))),
                        Container(
                          padding: EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 1.0),
                          width:
                          (MediaQuery
                              .of(context)
                              .size
                              .width) /
                              4,
                          child: Text(
                            snapshot.data.injured,textAlign: TextAlign.center,
                            //overflow: TextOverflow.ellipsis,
                            maxLines: 10,
                          style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 15.0,
                        ),)
                          ),
                      ],
                    ),
                  ),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: RaisedButton(
                          color: Colors.green,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              
                              child: Text(
                                "Akceptuj",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            onPressed: () {
                             
                                DBFuture().emergencyAccept(widget.groupId, widget.alertId, widget.userName);

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OurRoot(),
                                  ),
                                      (route) => false,
                                );

                            },
                            ),
                      ),

                      Container(
                       child: RaisedButton(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              child: Text(
                                "Odrzuć",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            onPressed: () {
                              DBFuture().emergencyReject(widget.groupId,widget.alertId, widget.userName );

                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OurRoot(),
                                ),
                                    (route) => false,
                              );

                            }

                        ),
                      ),
                    ]
                  ),

              
                ]
              )
            ),
          )];
      

          } else if (snapshot.hasError) {
            children = <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else {
            children = <Widget>[
              SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('ładowanie...'),
              )
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //         centerTitle: true,
  //         backgroundColor: Colors.amber,
  //         title: Text("",
  //             style: new TextStyle(
  //               fontWeight: FontWeight.bold,
  //               fontSize: 25.0,
  //             )),
  //         // leading: BackButton(
  //         //     color: Colors.black
  //         // ),
  //         leading: new IconButton(
  //           icon: new Icon(Icons.arrow_back, color: Colors.black),
  //           onPressed: () => Navigator.push(
  //               context, MaterialPageRoute(builder: (context) => OurRoot())),
  //         ),
  //       ),
  //     key: emergencyKey,
  //     body: Column(
  //       children: <Widget>[
  //         Padding(
  //           padding: const EdgeInsets.all(20.0),
            
  //         ),
  //         Spacer(),
  //         Padding(
  //           padding: const EdgeInsets.all(20.0),
  //           child: ShadowContainer(
  //             child: Column(
  //               children: <Widget>[
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                   children: <Widget>[
  //                     Text("Alarm!", style: TextStyle(
  //                       color: Colors.black,
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 18.0,
  //                     ),
  //                     ),
  //                   ],
  //                 ),
  //                 SizedBox(
  //                   height: 20.0,
  //                 ),
  //                 Container(
  //                   padding: EdgeInsets.symmetric(
  //                       horizontal: 10.0, vertical: 10.0),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                     children: [
  //                       Text("Miejsce zdarzenia: ",style: TextStyle(
  //                         color: Colors.black,
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 15.0,
  //                       ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Container(
  //                   padding: EdgeInsets.symmetric(
  //                       horizontal: 10.0, vertical: 10.0),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                     children: [
  //                       Text("Opis: ",style: TextStyle(
  //                         color: Colors.black,
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 15.0,
  //                       ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Container(
  //                   padding: EdgeInsets.symmetric(
  //                       horizontal: 10.0, vertical: 10.0),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                     children: [
  //                       Text("Liczba poszkodowanych: ",style: TextStyle(
  //                         color: Colors.black,
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 15.0,
  //                       ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                   children: <Widget>[
  //                     Container(
  //                       padding: EdgeInsets.symmetric(
  //                           horizontal: 5.0, vertical: 10.0),
  //                       child: Text("Potrzebny czas na przybycie: ", style: TextStyle(
  //                         color: Colors.black,
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 15.0,
  //                       ),
  //                       ),
  //                     ),
  //                     DropdownButton<String>(
  //                       value: _dropdownValue,
  //                       icon: Icon(Icons.arrow_downward),
  //                       iconSize: 24,
  //                       elevation: 16,
  //                       style: TextStyle(
  //                           color: Theme.of(context).secondaryHeaderColor),
  //                       underline: Container(
  //                         height: 2,
  //                         color: Theme.of(context).canvasColor,
  //                       ),
  //                       onChanged: (String newValue) {
  //                         setState(() {
  //                           _dropdownValue = newValue;
  //                         });
  //                       },
  //                       items: <String>["Na miejscu","~2 min.","~3 min.","~4 min.","~5 min.","~6 min.","~7 min.","~8 min.","~9 min.","+10 min."]
  //                           .map<DropdownMenuItem<String>>((String value) {
  //                         return DropdownMenuItem<String>(
  //                           value: value,
  //                           child: Text(value,style: TextStyle(
  //                             color: Colors.black,
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 15.0,
  //                           ),),
  //                         );
  //                       }).toList(),
  //                     ),
  //                   ],
  //                 ),
  //                 Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: <Widget>[
  //                     Container(
  //                       child: RaisedButton(
  //                           child: Padding(
  //                             padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
  //                             child: Text(
  //                               "Akceptuj",
  //                               style: TextStyle(
  //                                 color: Colors.green,
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 20.0,
  //                               ),
  //                             ),
  //                           ),
  //                           onPressed: () {
  //                             if (_dropdownValue != null) {
                                

  //                               Navigator.pushAndRemoveUntil(
  //                                 context,
  //                                 MaterialPageRoute(
  //                                   //builder: (context) => (),
  //                                 ),
  //                                     (route) => false,
  //                               );
  //                             } else {
  //                               emergencyKey.currentState.showSnackBar(SnackBar(
  //                                 content: Text("Musisz uzupełnic informację"),
  //                               ));
  //                             }
  //                           },
  //                           ),
  //                     ),

  //                     Container(
  //                      child: RaisedButton(
  //                           child: Padding(
  //                             padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
  //                             child: Text(
  //                               "Odrzóć",
  //                               style: TextStyle(
  //                                 color: Colors.redAccent,
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 20.0,
  //                               ),
  //                             ),
  //                           ),
  //                           onPressed: () {


  //                             Navigator.pushAndRemoveUntil(
  //                               context,
  //                               MaterialPageRoute(
  //                                 //builder: (context) => TaskList(),
  //                               ),
  //                                   (route) => false,
  //                             );

  //                           }

  //                       ),
  //                     ),
  //                   ]
  //                 ),


  //               ],
  //             ),
  //           ),
  //         ),
  //         Spacer(),
  //       ],
  //     ),
  //   );
  // }
}