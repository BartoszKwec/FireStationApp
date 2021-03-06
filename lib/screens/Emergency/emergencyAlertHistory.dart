
import 'package:fire_station_inz_app/models/EmergencyModel.dart';
import 'package:fire_station_inz_app/models/authModel.dart';
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

class EemergencyAlertHistory extends StatefulWidget {

 //final String userUid;
  // final String taskUid;
  final String groupId;

  //final Future<EmergencyModel> emergencyModel;

  EemergencyAlertHistory({@required this.groupId});
  @override
  _EemergencyAlertHistoryState createState() => _EemergencyAlertHistoryState();


}

class _EemergencyAlertHistoryState extends State<EemergencyAlertHistory> {
  //final emergencyKey = GlobalKey<ScaffoldState>();

 
  Future<List<EmergencyModel>> emergencyModel;



  Future<List<EmergencyModel>> getData()async{
    print(widget.groupId);
    print("22222222222");
    //return await DBFuture().getAlert1(widget.groupId);
    var model = await DBFuture().getAlertsHistory(widget.groupId);
    return model;
  }
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    emergencyModel = getData();
    print(emergencyModel);
    //userModel=await DBFuture().getUser()
    //var model = await DBFuture().getTasks(widget.userId);

    //GroupModel groupModel = await DBFuture().getGroup(widget.groupId);
    //List<UserModel> users = await DBFuture().getUsers(groupModel.members);
    // print(groupModel.members);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 202, 17, 0),
          title: Text("Historia alarmów",
              style: new TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
              )),
          // leading: BackButton(
          //     color: Colors.black
          // ),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => OurRoot())),
          ),
        ),
        body: FutureBuilder<List<EmergencyModel>>(
          //DBFuture().getUsers(groupModel.members)
          future: emergencyModel,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, index) =>
                      Container(
                        //color: (index % 2 == 0) ? Colors.white : Colors.white70,
                        //height: 300,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 5.0),

                        child: Card(
                          elevation: 10.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            padding:
                            EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    // Container(
                                    //   width: 55.0,
                                    //   height: 55.0,
                                    //   child: CircleAvatar(
                                    //     //backgroundImage: users[index].photoUrl,
                                    //     backgroundColor: Colors.red,
                                    //   ),
                                    // ),
                                    SizedBox(
                                      width: 4.0,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: <Widget>[
                                        Text(
                                            "Autor : "+snapshot.data[index].author ,
                                            style: new TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0)),
                                        
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 0.0, vertical: 10.0),
                                            width:
                                            (MediaQuery
                                                .of(context)
                                                .size
                                                .width) /
                                                1.5,
                                            child: Text(
                                             
                                             "Miejsce: "+snapshot.data[index].place,style: new TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0)
                                              //overflow: TextOverflow.ellipsis,
                                             
                                            )
                                            ),
                                            (Text("Opis : ",
                                            style: new TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0))),
                                            Container(
                                              
                                            width:
                                            (MediaQuery
                                                .of(context)
                                                .size
                                                .width) /
                                                1.5,
                                            child: Text(
                                             snapshot.data[index].description ,
                                             maxLines: 10,
                                             style: new TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15.0)
                                              //overflow: TextOverflow.ellipsis,
                                             
                                            )
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                              horizontal: 0.0, vertical: 5.0),
                                            width:
                                            (MediaQuery
                                                .of(context)
                                                .size
                                                .width) /
                                                1.1,
                                            child: Text(
                                             "Poszkodowani: "+snapshot.data[index].injured ,style: new TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0)
                                              //overflow: TextOverflow.ellipsis,
                                             
                                            )
                                            ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 5.0),
                                          alignment: Alignment.centerRight,
                                          //color: Colors.yellow,
                                          
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                );
              }
              
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
        
  }
 
  }