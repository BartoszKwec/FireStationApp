
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

class EmergencyEnd extends StatefulWidget {

  final String groupId;

  // final String taskUid;

  EmergencyEnd({@required this.groupId});
  @override
  _EmergencyEndState createState() => _EmergencyEndState();


}

class _EmergencyEndState extends State<EmergencyEnd> {
  final rankKey = GlobalKey<ScaffoldState>();
  TextEditingController _reviewController = TextEditingController();
  String _dropdownValue;
  AuthModel _authModel;


  @override
  void didChangeDependencies() {
    _authModel = Provider.of<AuthModel>(context);
    super.didChangeDependencies();
  }
  void _TaskList(){
    GroupModel group = Provider.of<GroupModel>(context, listen: false);
    Navigator.push(
      context,
      MaterialPageRoute(

        builder: (context) => UserList(
          groupId: group.id,
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
      key: rankKey,
      body: Column(
        children: <Widget>[
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ShadowContainer(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text("Na pewno chcesz zakończyć alarm?", style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 80),
                        child: Text(
                          "Tak",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      onPressed: () {
                       DBFuture().deleteEmergencyAlert(widget.groupId);

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OurRoot(
                                  //userId: widget.userUid,
                              ),
                            ),
                                (route) => false,
                          );

                        }

                  ),
                ],
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}