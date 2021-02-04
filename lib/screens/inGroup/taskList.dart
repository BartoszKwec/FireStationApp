import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_station_inz_app/models/groupModel.dart';
import 'package:fire_station_inz_app/models/membersModel.dart';
import 'package:fire_station_inz_app/models/taskModel.dart';
import 'package:fire_station_inz_app/models/userModel.dart';
import 'package:fire_station_inz_app/screens/rank/rank.dart';
import 'package:fire_station_inz_app/screens/root/root.dart';
import 'package:fire_station_inz_app/screens/task/deleteTask.dart';
import 'package:fire_station_inz_app/screens/task/task.dart';
import 'package:fire_station_inz_app/services/dbFuture.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'inGroup.dart';
import 'local_widgets/eachUser.dart';

Firestore _firestore = Firestore.instance;

class TaskList extends StatefulWidget {
  final String userId;

  TaskList({this.userId});

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  //Future<List<UserModel>> userModel;
  //List<UserModel> users;
  // UserModel _userRank;
  UserModel userModel;
  Future<List<TaskModel>> taskModel;
  String taskUid;
  String userUid;

  Future<List<TaskModel>> getData() async {
    var model = await DBFuture().getTasks(widget.userId);
    return model;
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    taskModel = getData();
    print(taskModel);
    //userModel=await DBFuture().getUser()
    //var model = await DBFuture().getTasks(widget.userId);

    //GroupModel groupModel = await DBFuture().getGroup(widget.groupId);
    //List<UserModel> users = await DBFuture().getUsers(groupModel.members);
    // print(groupModel.members);
  }
  void _goToDeleteTask(String userUid, String taskUid) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeleteTask(
          taskUid: taskUid,
          userUid: userUid,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.amber,
          title: Text("Zadania",
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
        body: FutureBuilder<List<TaskModel>>(
          //DBFuture().getUsers(groupModel.members)
          future: taskModel,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data.isNotEmpty) {
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
                                            "Autor : " +
                                                snapshot.data[index]
                                                    .authorEmail,
                                            style: new TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25.0)),
                                        (snapshot.data[index].priority ==
                                            "Niskie")
                                            ? (Text("Priorytet: Niskie",
                                            style: new TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20.0)))
                                            : (snapshot.data[index].priority ==
                                            "Ważne")
                                            ? (Text("Priorytet: Ważne",
                                            style: new TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20.0)))
                                            : (Text("Priorytet: Średnie",
                                            style: new TextStyle(
                                                color: Colors.orange,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20.0))),
                                        (Text("Treść zadania : ",
                                            style: new TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15.0))),
                                        Container(
                                            width:
                                            (MediaQuery
                                                .of(context)
                                                .size
                                                .width) /
                                                1.1,
                                            child: Text(
                                              snapshot.data[index].contents,
                                              //overflow: TextOverflow.ellipsis,
                                              maxLines: 10,
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
                                              // IconButton(
                                              //   iconSize: 35,
                                              //   onPressed: () {
                                              //    // DBFuture().DeleteTask(snapshot.data[index].userUid,snapshot.data[index].id);
                                              //     userUid=snapshot.data[index].userUid;
                                              //     taskUid=snapshot.data[index].id;
                                              //     _goToDeleteTask(userUid, taskUid);
                                              //   },
                                              //   color: Colors.red,
                                              //   icon: Icon(Icons.clear),
                                              //   //alignment: Alignment.centerRight,
                                              // ),
                                              IconButton(
                                                iconSize: 35,
                                                onPressed: () {
                                                  return Alert(context: context,
                                                      title: "Usuwanie zadania",
                                                      desc:"Czy napewno chcesz usunąć zadanie?",
                                                      buttons: [
                                                        DialogButton(
                                                          child: Text("Tak",
                                                              style: new TextStyle(
                                                                  fontWeight: FontWeight.normal,
                                                                  fontSize: 20.0,
                                                              color: Colors.red)),
                                                          onPressed: (){
                                                            DBFuture().deleteTask(snapshot.data[index].userUid,snapshot.data[index].id);
                                                            Navigator.pushAndRemoveUntil(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => TaskList(
                                                                  userId: snapshot.data[index].userUid,
                                                                ),
                                                              ),
                                                                  (route) => false,
                                                            );
                                                          },
                                                        )
                                                      ]
                                                  )
                                                      .show();
                                                },
                                                color: Colors.red,
                                                icon: Icon(Icons.clear),
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
                child: Text("Brak Zadań",style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0)),
              );
            }else // tutaj zmiana
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
