
import 'package:fire_station_inz_app/models/EmergencyModel.dart';
import 'package:fire_station_inz_app/models/authModel.dart';
import 'package:fire_station_inz_app/models/groupModel.dart';
import 'package:fire_station_inz_app/models/userModel.dart';
import 'package:fire_station_inz_app/screens/Emergency/emergencyAlertHistory.dart';
import 'package:fire_station_inz_app/screens/root/root.dart';
import 'package:fire_station_inz_app/services/dbFuture.dart';
import 'package:fire_station_inz_app/widgets/shadowContainer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class Emergency extends StatefulWidget {
  final String groupId;
  final String userName;
  final String userGroupId;


  Emergency({@required this.groupId, this.userName, this.userGroupId});
  @override
  _EmergencyState createState() => _EmergencyState();
}

class _EmergencyState extends State<Emergency> {
  final emergencyKey = GlobalKey<ScaffoldState>();
  TextEditingController _placeController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String aaaa;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

EmergencyModel emergencyModel;
  String _dropdownValue;
  AuthModel _authModel;

  @override
  void didChangeDependencies() {
    _authModel = Provider.of<AuthModel>(context);
    super.didChangeDependencies();
  }
  @override
  void initState() {
    super.initState();
    var androidInitilize = new AndroidInitializationSettings('app_icon');
    var iOSinitilize = new IOSInitializationSettings();
    var initilizationsSettings =
        new InitializationSettings(androidInitilize, iOSinitilize);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initilizationsSettings,
        onSelectNotification: notificationSelected);
  }
  Future notificationSelected(String userGroupId) async {
  showDialog(
    context: context,
    builder: (context) =>  EemergencyAlertHistory(groupId: userGroupId),

  );
}
  Future _showNotification() async {
  var androidDetails = new AndroidNotificationDetails(
      "ID", "topic", "opis",
      sound: RawResourceAndroidNotificationSound("aaa"),
      playSound: true,
      importance: Importance.Max,
      priority: Priority.High);
  var iSODetails = new IOSNotificationDetails();
  var generalNotificationDetails =
      new NotificationDetails(androidDetails, iSODetails);

   await flutterLocalNotificationsPlugin.show(
       2, "ALARM!", "Utworzyłeś alarm. Wszystkie osoby zostaną poinformowane.", 
       generalNotificationDetails, payload: "ALARM!");
}
  
  void _emergencyCreate(EmergencyModel emergencyModel, String groupId, String userName) {
    DBFuture().createEmergency(groupId, emergencyModel, userName);
    DBFuture().createEmergencyHistory(groupId, emergencyModel, userName);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OurRoot(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: emergencyKey,
      body: ListView(
        
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(

                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 20.0),
                           child: Text("Tworzenie alarmu", style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0,
                            ),
                            ),
                          ),



                        ],
                      ),

                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                      child: Text("Miejsce zdarzenia: ", style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                      ),
                  ),

                  TextFormField(
                    controller: _placeController,
                    maxLines: 1,
                    maxLength: 50,
                    decoration: InputDecoration(
                      hintText: "Ulica, numer drogi",

                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    child: Text("Opis zdarzenia: ", style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                    ),
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: "Co się wydarzyło? Opis sytuacji.",
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 20.0),
                        child: Text("Liczba poszkodowanych: ", style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.0,
                        ),
                        ),
                      ),
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
                        items: <String>["Brak","Brak danych","1 osoba","2 osoby","3 osoby","4 osoby","5 osób","+5 osób",]
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 9.0,
                  ),
                  RaisedButton(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 80),
                      child: Text(
                        "Utwórz",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    onPressed: () {
                      EmergencyModel emergency = EmergencyModel();
                      if (_placeController.text == "") {
                        emergencyKey.currentState.showSnackBar(SnackBar(
                          content: Text("Musisz dodać miejsce zdarzenia"),
                        ));
                      } else if (_descriptionController.text == "") {
                        emergencyKey.currentState.showSnackBar(SnackBar(
                          content: Text("Musisz dodać opis"),
                        ));
                      } else if (_dropdownValue== null){
                        emergencyKey.currentState.showSnackBar(SnackBar(
                          content: Text("Musisz uzupełnic informację o poszkodowanych"),
                        ));
                      }else {
                        emergency.place = _placeController.text;
                        emergency.description = _descriptionController.text;
                        emergency.injured=_dropdownValue;
                        emergency.view=true;
                        _emergencyCreate(emergency, widget.groupId, widget.userName);
                        _showNotification();
                      }
                    },
                  ),
                  
                  // RaisedButton(
                  //   child: Padding(
                  //     padding: EdgeInsets.symmetric(horizontal: 80),
                  //     child: Text(
                  //       "Testt2",
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 20.0,
                  //       ),
                  //     ),
                  //   ),
                  //   onPressed: () {
                  //     if (_dropdownValue != null) {
                  //
                  //       Navigator.pushAndRemoveUntil(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => EmergencyWait(
                  //             groupId: widget.groupId,
                  //           ),
                  //         ),
                  //             (route) => false,
                  //       );
                  //     } else {
                  //       emergencyKey.currentState.showSnackBar(SnackBar(
                  //         content: Text("Musisz uzupełnic informację"),
                  //       ));
                  //     }
                  //   },
                  // ),
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