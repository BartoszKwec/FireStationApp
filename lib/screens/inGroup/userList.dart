import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_station_inz_app/models/groupModel.dart';
import 'package:fire_station_inz_app/models/membersModel.dart';
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

class UserList extends StatefulWidget {
  final String groupId;

  UserList({this.groupId});

  @override
  _UserListState createState() => _UserListState();

}



class _UserListState extends State<UserList> {

  Future<List<UserModel>> userModel;
  //List<UserModel> users;
  UserModel _userRank;
  UserModel _userModel;

  Future<List<UserModel>> getData() async {
    var model = await DBFuture().getGroup(widget.groupId);
    return await DBFuture().getUsers(model.members);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    userModel=getData();
    GroupModel groupModel = await DBFuture().getGroup(widget.groupId);
    //List<UserModel> users = await DBFuture().getUsers(groupModel.members);
    // print(groupModel.members);

  }
  void _goToRank(UserModel _userRank) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Rank(
          userRank: _userRank,
        ),
      ),
    );
  }
  void _goToTask(UserModel _userModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Task(
          userModel: _userModel,
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
        title: Text(
          "Lista osób",style: new TextStyle(
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
    body: FutureBuilder<List<UserModel>>(
        //DBFuture().getUsers(groupModel.members)
      future: userModel,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {

          return ListView.builder(
            itemCount: snapshot.data.length,
            shrinkWrap: true,

            itemBuilder: (BuildContext context, index) =>
                Container(
                  //color: (index % 2 == 0) ? Colors.white : Colors.white70,

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
                                  Text(snapshot.data[index].fullName,
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25.0)),
                                  Text((snapshot.data[index].rank=="" ||snapshot.data[index].rank==null)?("Ranga: brak rangi"):("Ranga: "+snapshot.data[index].rank)),
                                ],
                              ),
                              Container(
                                alignment: Alignment.centerRight,

                                child: IconButton(

                                    onPressed: () {
                                      _userRank=snapshot.data[index];
                                      _goToRank(_userRank);
                                    },

                                    color: Colors.blue,
                                    icon: Icon(Icons.person)
                                ),

                              ),
                              Container(
                                alignment: Alignment.centerRight,

                                child: IconButton(

                                    onPressed: () {
                                      _userModel=snapshot.data[index];
                                      _goToTask(_userModel);
                                    },
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
        return Center(child: CircularProgressIndicator(

        ),
        );
      },
    )
    );


  }

}

