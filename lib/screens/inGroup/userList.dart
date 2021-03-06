import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_station_inz_app/models/groupModel.dart';
import 'package:fire_station_inz_app/models/membersModel.dart';
import 'package:fire_station_inz_app/models/userModel.dart';
import 'package:fire_station_inz_app/screens/inGroup/taskList.dart';
import 'package:fire_station_inz_app/screens/inGroup/taskListAnother.dart';
import 'package:fire_station_inz_app/screens/rank/rank.dart';
import 'package:fire_station_inz_app/screens/root/root.dart';
import 'package:fire_station_inz_app/screens/task/task.dart';
import 'package:fire_station_inz_app/services/dbFuture.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'inGroup.dart';
import 'local_widgets/eachUser.dart';

Firestore _firestore = Firestore.instance;

class UserList extends StatefulWidget {
  final String groupId;
  final bool userRank;

  UserList({this.groupId, this.userRank});

  @override
  _UserListState createState() => _UserListState();

}



class _UserListState extends State<UserList> {

  Future<List<UserModel>> userModel;
  //List<UserModel> users;
  UserModel _userRank;
  UserModel _userModel;
  //bool button ;

  Future<List<UserModel>> getData() async {
    var model = await DBFuture().getGroup(widget.groupId);
    return await DBFuture().getUsers(model.members);
  }

  @override
  void didChangeDependencies() async {

    super.didChangeDependencies();
    print("jestem w liście"+widget.userRank.toString());
    //button=widget.userRank;
    userModel=getData();
    //print(widget.userRank);
    GroupModel groupModel = await DBFuture().getGroup(widget.groupId);
    //List<UserModel> users = await DBFuture().getUsers(groupModel.members);
    // print(groupModel.members);

  }
  //  void checkRank(bool button){

  //   if(widget.userRank=="Dowódca"){
  //     button=false;
  //     print(widget.userRank+"jestem tu");

  //   }
  // }
  
  void _goToRank(UserModel _userRank, bool boolRank) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Rank(
          userRank: _userRank,
          boolRank: boolRank,
        ),
      ),
    );
  }
  void _goToTask(UserModel _userModel, bool userRank) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Task(
          userModel: _userModel,
          userRank: userRank,
        ),
      ),
    );
  }
  void _goToUserTask(UserModel _userModel, bool userRank){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskListAnother(
          userId: _userModel.uid,
          userRank: userRank,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 202, 17, 0),
        title: Text(
          "Lista osób",style: new TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25.0,

        )
        ),
        // leading: BackButton(
        //     color: Colors.black
        // ),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.push(context,MaterialPageRoute(
            builder: (context)=>OurRoot()
          )
          ),
        ),

      ),
    body: FutureBuilder<List<UserModel>>(
      future: userModel,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {

          return ListView.builder(
            itemCount: snapshot.data.length,
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

                              SizedBox(
                                width: 5.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Email: "+snapshot.data[index].email, style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                                  Text("Nazwa: "+snapshot.data[index].fullName,
                                      style: new TextStyle(fontWeight: FontWeight.normal, fontSize: 20.0)),
                                  Text((snapshot.data[index].rank=="" ||snapshot.data[index].rank==null)?("Ranga: brak rangi"):("Ranga: "+snapshot.data[index].rank)),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5.0),
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: <Widget>[
                                        
                                     AbsorbPointer(
                                          absorbing: widget.userRank,
                                          
                                         child: IconButton(
                                           disabledColor: Colors.grey,
                                            onPressed : widget.userRank ? null :  ()=> _goToRank(_userRank=snapshot.data[index], widget.userRank),
                                            

                                            color: Colors.blue,
                                            icon: Icon(Icons.person)
                                        
                                        ),
                                     ),
                                        AbsorbPointer(
                                          absorbing: widget.userRank,
                                          
                                         child: IconButton(
                                           
                                            disabledColor: Colors.grey,
                                            onPressed: widget.userRank ? null : () => _goToTask(_userModel=snapshot.data[index], widget.userRank),
                                            color: Colors.red,
                                            icon: Icon(Icons.event)
                                        ),
                                        ),
                                        
                                        IconButton(

                                            onPressed: () {
                                              _userModel=snapshot.data[index];
                                              _goToUserTask(_userModel, widget.userRank);
                                            },
                                            color: Colors.yellow[800],
                                            icon: Icon(Icons.event_note)
                                        ),
                                        // Container(
                                          
                                        //   child: RaisedButton(
                                          
                                        //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(100.0))),
                                        //     onPressed: widget.userRank ? null : () => _goToRank(_userModel=snapshot.data[index], widget.userRank),
                                        //     child: Row(
                                        //       children: <Widget>[
                                        //         Padding(
                                        //           padding: EdgeInsets.fromLTRB(4, 0, 10, 0),
                                        //           child: Icon(Icons.person),
                                        //         ),
                                        //       ],
                                        //     ),
                                            
                                        //   ),
                                        // ),
                                        
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
        return Center(child: CircularProgressIndicator(

        ),
        );
      },
    )
    );


  }

}

