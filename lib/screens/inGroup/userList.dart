import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_station_inz_app/models/groupModel.dart';
import 'package:fire_station_inz_app/models/membersModel.dart';
import 'package:fire_station_inz_app/models/userModel.dart';
import 'package:fire_station_inz_app/services/dbFuture.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'local_widgets/eachUser.dart';

Firestore _firestore = Firestore.instance;

class UserList extends StatefulWidget {
  final String groupId;

  UserList({this.groupId});

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<String> members;
  List<UserModel>users;
  int dlu;
  GroupModel groupModel;


  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    groupModel = await DBFuture().getGroup(widget.groupId);
    users = await DBFuture().getUsers(groupModel.members);
    print(groupModel.members);
    dlu = groupModel.members.length;
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserModel>>(
      future: DBFuture().getUsers(groupModel.members),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: dlu,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, index) =>
                Container(

                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
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
                      padding: EdgeInsets.symmetric(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(users[index].fullName,
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25.0)),
                                  Text("Ranga: "),
                                ],
                              ),
                              Container(
                                alignment: Alignment.centerRight,

                                child: IconButton(

                                    onPressed: () {},
                                    color: Colors.blue,
                                    icon: Icon(Icons.person)
                                ),

                              ),
                              Container(
                                alignment: Alignment.centerRight,

                                child: IconButton(

                                    onPressed: () {},
                                    color: Colors.red,
                                    icon: Icon(Icons.event_note)
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerRight,

                                child: IconButton(

                                    onPressed: () {},
                                    color: Colors.yellow,
                                    icon: Icon(Icons.email)
                                ),
                              ),


                            ],
                          ),

                          // Container(
                          //   alignment: Alignment.center,
                          //   padding: EdgeInsets.symmetric(
                          //       horizontal: 5.0, vertical: 5.0),
                          //   child: IconButton(
                          //
                          //       onPressed: () {},
                          //       color: Colors.blue,
                          //       icon: Icon(Icons.person)
                          //   ),
                          // ),
                          // Container(
                          //   alignment: Alignment.center,
                          //   padding: EdgeInsets.symmetric(
                          //       horizontal: 5.0, vertical: 5.0),
                          //   child: IconButton(
                          //
                          //       onPressed: () {},
                          //       color: Colors.red,
                          //       icon: Icon(Icons.email)
                          //   ),
                          // ),
                          // Container(
                          //   alignment: Alignment.center,
                          //   padding: EdgeInsets.symmetric(
                          //       horizontal: 5.0, vertical: 5.0),
                          //   child: IconButton(
                          //
                          //       onPressed: () {},
                          //       color: Colors.yellow,
                          //       icon: Icon(Icons.smartphone)
                          //   ),
                          // ),
                          // Container(
                          //   alignment: Alignment.center,
                          //   padding: EdgeInsets.symmetric(
                          //       horizontal: 5.0, vertical: 5.0),
                          //   child: IconButton(
                          //
                          //       onPressed: () {},
                          //       color: Colors.green,
                          //       icon: Icon(Icons.event)
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
          );
        }
        return Center(child: CircularProgressIndicator(),);
      },
    );
  }
}
