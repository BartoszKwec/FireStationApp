
import 'package:fire_station_inz_app/models/authModel.dart';
import 'package:fire_station_inz_app/models/groupModel.dart';
import 'package:fire_station_inz_app/models/userModel.dart';
import 'package:fire_station_inz_app/screens/inGroup/userList.dart';
import 'package:fire_station_inz_app/screens/root/root.dart';
import 'package:fire_station_inz_app/services/dbFuture.dart';
import 'package:fire_station_inz_app/widgets/shadowContainer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
FirebaseAuth auth = FirebaseAuth.instance;
class Task extends StatefulWidget {
  final UserModel userModel;


  Task({@required this.userModel});
  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> {
  final taskKey = GlobalKey<ScaffoldState>();
  TextEditingController _taskController = TextEditingController();
  String _dropdownValue;
  AuthModel _authModel;
  FirebaseUser emailAuthor;
  String user1;

  // void inputData() async {
  //   final FirebaseUser nameAuthor = await auth.currentUser();
  //
  // }


  @override
  void didChangeDependencies() async{
    _authModel = Provider.of<AuthModel>(context);
    super.didChangeDependencies();
    emailAuthor = await auth.currentUser();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: taskKey,
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
                      Text("Nadaj priorytet:"),
                      DropdownButton<String>(
                        value: _dropdownValue,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor),
                        underline: Container(
                          height: 2,
                          color: Theme.of(context).canvasColor,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            _dropdownValue = newValue;
                          });
                        },
                        items: <String>["Ważne","Średnie","Niskie"]
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _taskController,
                    maxLines: 10,
                    decoration: InputDecoration(
                      hintText: "Dodaj treść zadania.",
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 80),
                      child: Text(
                        "Dodaj Zadanie",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (_dropdownValue != null) {
                        DBFuture().addTask(widget.userModel.uid, _taskController.text, _dropdownValue, emailAuthor.email);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserList(
                              groupId: widget.userModel.groupId,
                            ),
                          ),
                              (route) => false,
                        );
                      } else {
                        taskKey.currentState.showSnackBar(SnackBar(
                          content: Text("Musisz nadać priorytet!"),
                        ));
                      }
                    },
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