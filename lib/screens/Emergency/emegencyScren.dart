
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_station_inz_app/models/EmergencyModel.dart';
import 'package:fire_station_inz_app/models/groupModel.dart';
import 'package:fire_station_inz_app/models/userModel.dart';
import 'package:fire_station_inz_app/screens/Emergency/emergencyCreate.dart';
import 'package:fire_station_inz_app/screens/eventHistory/eventHistory.dart';
import 'package:fire_station_inz_app/screens/inGroup/taskList.dart';
import 'package:fire_station_inz_app/screens/inGroup/userList.dart';
import 'package:fire_station_inz_app/screens/root/root.dart';
import 'package:fire_station_inz_app/screens/task/task.dart';
import 'package:fire_station_inz_app/services/auth.dart';
import 'package:fire_station_inz_app/services/dbFuture.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'EmergencyAlert.dart';
import 'emergencyAlertHistory.dart';


class EmergencyScreen extends StatefulWidget {

bool group;
String groupId;
String userName;
String userGroupId;
String groupAlertId;

  EmergencyScreen({@required this.group, this.groupAlertId, this.groupId, this.user, this.userGroupId, this.userName});
  @override
  EmergencyScreenState createState() => EmergencyScreenState();

  

  FirebaseUser user;
}

class EmergencyScreenState extends State<EmergencyScreen> {
Future<GroupModel> groupModel1;
bool _isButtonDisabled=false;
bool _isButtonDisabledEnd;
bool _isButtonDisabledAlert;
GroupModel groupModel2;
bool view;
// Future<EmergencyModel> emergencyModel;

Firestore _firestore = Firestore.instance;
// Future<EmergencyModel> getData()async{
//     return await DBFuture().getAlert(widget.groupId);
//   }
  final key = new GlobalKey<ScaffoldState>();
  @override
  void didChangeDependencies() async{
    super.didChangeDependencies();
    final FirebaseUser userr = await auth.currentUser();
    // emergencyModel=getData();
    //groupModel1=DBFuture().getGroup(widget.groupId);
    //_checkEvent();
    

  }
  
  
  void _checkEvent(BuildContext context)async{
   //GroupModel group = Provider.of<GroupModel>(context, listen: false);
    
    if (widget.group) {
      _isButtonDisabled = true;
      _isButtonDisabledAlert=false;
      _isButtonDisabledEnd= false;
    } else {
      _isButtonDisabled = false;
      _isButtonDisabledAlert=true;
      _isButtonDisabledEnd= true;
    }
  }

  void _Emergency(){
    // GroupModel group = Provider.of<GroupModel>(context, listen: false);
    // UserModel user = Provider.of<UserModel>(context, listen: false);
    Navigator.push(
      context,
      MaterialPageRoute(

        builder: (context) => Emergency(
          groupId: widget.groupId,
          userName: widget.userName,
          userGroupId: widget.userGroupId,
        ),
      ),
    );
  }
  void _EmergencyAlert(){
    
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => EmergencyAlert(
            groupId: widget.groupId,
          ),
        ),
            (route) => false,
      );
    
          
  }
   void _EmergencyAlertHistory(){
    
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => EemergencyAlertHistory(
            groupId: widget.groupId,
          ),
        ),
            (route) => false,
      );
    
          
  }

  // bool DuringEvent(){
  //   GroupModel group = Provider.of<GroupModel>(context, listen: false);
  //   if (group.duringEmergency=="false") {
  //     return true;
  //   } else {
  //     return false;
  //   }
    
  // }

  @override
  Widget build(BuildContext context) {
    _checkEvent(context);
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.amber,
          title: Text("System Alarmów",
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

      key: key,
      body: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              //   child: IconButton(
              //     onPressed: () => _signOut(context),
              //     icon: Icon(Icons.exit_to_app),
              //     color: Theme.of(context).secondaryHeaderColor,
              //   ),
              // ),
            ],
          ),
          
            _buildCounterButton(),
            _buildButtonActualAlert(),
            _buildButtonEnd(),
            
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
              
              child: RaisedButton(
              child: Text(
                "Historia alarmów",
                
              ),
              
               onPressed:  () => _EmergencyAlertHistory(),
            ),
            
          ),
          
        ],
      ),
    );
  }
  Widget _buildCounterButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: RaisedButton(
      child: new Text(
        _isButtonDisabled ? "Aktualnie trwa zdarzenie" : "Utwórz alarm"
      ),
      onPressed: _isButtonDisabled ? null : _Emergency,
    ),
    );
  }
  Widget _buildButtonActualAlert() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: RaisedButton(
      child: new Text(
        _isButtonDisabledAlert ? "Aktualnie nie ma alarmu" : "wyswietl alarm"
      ),
      onPressed: _isButtonDisabledAlert ? null : _EmergencyAlert,
    ),
    );
  }
  Widget _buildButtonEnd() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: RaisedButton(
      
      
      child: new Text(
        _isButtonDisabledEnd ? "Nie ma alarmu do zakończenia" : "Zakończ alarm"
      ),
      onPressed: _isButtonDisabledEnd  ? null : _Emergency,
      ), 
    );
  }

}
  