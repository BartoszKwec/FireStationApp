
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

class EmergencyInGroup extends StatefulWidget {

 //final String userUid;
  // final String taskUid;
  final String groupId;

  //final Future<EmergencyModel> emergencyModel;

  EmergencyInGroup({@required this.groupId});
  @override
  _EmergencyInGroupState createState() => _EmergencyInGroupState();


}

class _EmergencyInGroupState extends State<EmergencyInGroup> {
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
          backgroundColor: Colors.amber,
          title: Text("Aktualny ALARM",
              style: new TextStyle(
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
                                      width: 5.0,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: <Widget>[
                                        Text(
                                            "Autor : "+snapshot.data[index].author ,
                                            style: new TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25.0)),
                                        
                                        Container(
                                            width:
                                            (MediaQuery
                                                .of(context)
                                                .size
                                                .width) /
                                                1.1,
                                            child: Text(
                                             "dsfasd"
                                              //overflow: TextOverflow.ellipsis,
                                              
                                            )),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10.0),
                                          alignment: Alignment.centerRight,
                                          //color: Colors.yellow,
                                          child: Row(
                                            //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              IconButton(
                                                iconSize: 35,
                                                onPressed: () {},
                                                color: Colors.green,
                                                icon: Icon(Icons.check),
                                                //alignment: Alignment.centerRight,
                                              ),
                                              
                                            
                                            ],
                                          ),
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