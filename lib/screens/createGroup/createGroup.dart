
import 'package:fire_station_inz_app/models/userModel.dart';
import 'package:fire_station_inz_app/screens/addEvent/addEvent.dart';
import 'package:fire_station_inz_app/screens/root/root.dart';
import 'package:fire_station_inz_app/services/dbFuture.dart';
import 'package:fire_station_inz_app/widgets/shadowContainer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateGroup extends StatefulWidget {
  final UserModel userModel;

  CreateGroup({this.userModel});

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  void _goToAddEvent(BuildContext context, String groupName, UserModel userModel) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OurAddEvent(
         currentUser: userModel,
          onGroupCreation: true,
          onError: false,
          groupName: groupName,
        ),
      ),
    );
  }
  void _createGroup(BuildContext context, String groupName) async {
    print(widget.userModel.notifToken);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OurAddEvent(
          currentUser: widget.userModel,
          onGroupCreation: true,
          onError: false,
          groupName: groupName,
        ),
      ),
    );
  }
  void _createGroupBase(BuildContext context, String groupName) async {
    final FirebaseUser user = await auth1.currentUser();
    UserModel _currentUser = widget.userModel;
    //var user= FirebaseAuth.instance.currentUser();
    String _returnString = await DBFuture().createGroupBase(groupName,widget.userModel);

    if (_returnString == "success") {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => OurRoot(),
          ),
              (route) => false);
    }
  }

  TextEditingController _groupNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  TextFormField(
                    controller: _groupNameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.group),
                      hintText: "Nazwa grupy:",
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  // RaisedButton(
                  //   child: Padding(
                  //     padding: EdgeInsets.symmetric(horizontal: 80),
                  //     child: Text(
                  //       "Stwórz z wydarzeniem",
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 20.0,
                  //       ),
                  //     ),
                  //   ),
                  //   onPressed: () =>
                  //       _goToAddEvent(context, _groupNameController.text, widget.userModel ),
                  // ),
                  
                  RaisedButton(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 80),
                      child: Text(
                        "Stwórz",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    onPressed: () =>
                        _createGroupBase(context, _groupNameController.text, ),
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