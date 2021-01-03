import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_station_inz_app/models/groupModel.dart';
import 'package:fire_station_inz_app/models/membersModel.dart';
import 'package:fire_station_inz_app/models/taskModel.dart';
import 'package:fire_station_inz_app/models/userModel.dart';
import 'package:fire_station_inz_app/screens/rank/rank.dart';
import 'package:fire_station_inz_app/screens/root/root.dart';
import 'package:fire_station_inz_app/screens/task/task.dart';
import 'package:fire_station_inz_app/services/dbFuture.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  Future<List<TaskModel>> getData() async {
    var model = await DBFuture().getTasks(widget.userId);
    return model;
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    taskModel=getData();

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
          title: Text(
              "Zadania",style: new TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25.0,

          )
          ),
          // leading: BackButton(
          //     color: Colors.black
          // ),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.push(context,MaterialPageRoute(
                builder: (context)=>OurRoot()
            )
            ),
          ),

        ),
        body: FutureBuilder<List<TaskModel>>(
          //DBFuture().getUsers(groupModel.members)
          future: taskModel,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {

              return ListView.builder(
                itemCount: snapshot.data.length,
                shrinkWrap: true,

                itemBuilder: (BuildContext context, index) =>
                    Container(
                      //color: (index % 2 == 0) ? Colors.white : Colors.white70,
                      height: 300,
                      // width: MediaQuery
                      //     .of(context)
                      //     .size
                      //     .width,
                      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),

                      child: Card(
                        elevation: 10.0,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Container(
                          // width: MediaQuery
                          //     .of(context)
                          //     .size
                          //     .width,
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 10.0),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              Row(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.start,
                                // verticalDirection: down,
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("Autor : "+snapshot.data[index].authorEmail, style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25.0)),
                                      (snapshot.data[index].priority=="Niskie")?
                                      (Text("Priorytet: Niskie", style: new TextStyle(color: Colors.green, fontSize: 20.0))):
                                      (snapshot.data[index].priority=="Ważne")?
                                      (Text("Priorytet: Ważne", style: new TextStyle(color: Colors.red, fontSize: 20.0))):
                                      (Text("Priorytet: Średnie", style: new TextStyle(color: Colors.orange, fontSize: 20.0))),
                                      Expanded(child: Text("Zadanie : "+snapshot.data[index].contents,overflow: TextOverflow.ellipsis, ))

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
            return Center(child: CircularProgressIndicator(

            ),
            );
          },
        )
    );


  }

}

