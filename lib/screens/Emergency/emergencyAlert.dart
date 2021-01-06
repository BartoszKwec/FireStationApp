
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

class EmergencyAlert extends StatefulWidget {

 //final String userUid;
  // final String taskUid;
  final String groupId;

  EmergencyAlert({@required this.groupId});
  @override
  _EmergencyAlertState createState() => _EmergencyAlertState();


}

class _EmergencyAlertState extends State<EmergencyAlert> {
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
      key: rankKey,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[BackButton()],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ShadowContainer(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text("Alarm!", style: TextStyle(
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
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: RaisedButton(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              child: Text(
                                "Akceptuj",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            onPressed: () {

                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  //builder: (context) => (),
                                ),
                                    (route) => false,
                              );

                            }

                        ),
                      ),
                      Container(
                       child: RaisedButton(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              child: Text(
                                "Odrzóć",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            onPressed: () {


                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  //builder: (context) => TaskList(),
                                ),
                                    (route) => false,
                              );

                            }

                        ),
                      ),
                    ]
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