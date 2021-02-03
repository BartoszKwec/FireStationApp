
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_station_inz_app/models/eventModel.dart';
import 'package:fire_station_inz_app/models/userModel.dart';
import 'package:fire_station_inz_app/screens/root/root.dart';
import 'package:fire_station_inz_app/services/dbFuture.dart';
import 'package:fire_station_inz_app/widgets/shadowContainer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

final FirebaseAuth auth1 = FirebaseAuth.instance;

void inputData()async{
  final FirebaseUser user = await auth1.currentUser();
  final uid = user.uid;


}

class OurAddEvent extends StatefulWidget {
  final bool onGroupCreation;
  final bool onError;
  final String groupName;
  final UserModel currentUser;
  //final UserModel userModel;


  OurAddEvent({
    this.onGroupCreation,
    this.onError,
    this.groupName,
    this.currentUser,
    //this.userModel
  });
  @override
  _OurAddEventState createState() => _OurAddEventState();
}

class _OurAddEventState extends State<OurAddEvent> {

  final addEventKey = GlobalKey<ScaffoldState>();

  TextEditingController _eventNameController = TextEditingController();
  TextEditingController _authorController = TextEditingController();
  TextEditingController _lengthController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  initState() {
    super.initState();
    _selectedDate = DateTime(_selectedDate.year, _selectedDate.month,
        _selectedDate.day, _selectedDate.hour, 0, 0, 0, 0);
  }

  Future<void> _selectDate() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2222));

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = DateTime(picked.year, picked.month, picked.day,
            _selectedDate.hour, 0, 0, 0, 0);
      });
    }
  }

  Future _selectTime() async {
    await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return new NumberPickerDialog.integer(
          minValue: 0,
          maxValue: 23,
          initialIntegerValue: 0,
          infiniteLoop: true,
        );
      },
    ).then((num value) {
      if (value != null) {
        setState(() {
          _selectedDate = DateTime(_selectedDate.year, _selectedDate.month,
              _selectedDate.day, value, 0, 0, 0, 0);
        });
      }
    });
  }


  void _addEvent(BuildContext context,UserModel userModel, String groupName, EventModel event) async {
    String _returnString;
    // final FirebaseUser user = await auth1.currentUser();
    // final uid = user.uid;
    //UserModel _currentUser = widget.userModel;
     print("HAHDASHDAHSDHASHDAS");
    print("HAHDASHDAHSDHASHDAS"+ widget.currentUser.notifToken);


    if (_selectedDate.isAfter(DateTime.now().add(Duration(days: 1)))) {
      
    DBFuture().createEvent(widget.currentUser.groupId, event);
    Navigator.push(
      context,
      MaterialPageRoute(

        builder: (context) => OurRoot(
          
        ),
      ),
    );
  

      
        
      
    } else {
      addEventKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Termin jest mniejszy niż jeden dzień od teraz!"),
        ),
      );
    }
  }

  // Future<void> _createGroup(BuildContext context, String groupName) async {
  //   UserModel _currentUser = Provider.of<UserModel>(context, listen: false);
  //   var user= FirebaseAuth.instance.currentUser;
  //   String _returnString = await DBFuture().createGroupBase(groupName,_currentUser);
  //   if(_returnString=="success"){
  //     Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context)=>OurRoot(),
  //         ),
  //             (route) => false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: addEventKey,
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[BackButton()],
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ShadowContainer(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _eventNameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.event),
                      hintText: "Nazwa wydarzenia",
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: _authorController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person_outline),
                      hintText: "Opis",
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: _lengthController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.format_list_numbered),
                      hintText: "Długość wydarzenia w godz.",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(DateFormat.yMMMMd("en_US").format(_selectedDate)),
                  Text(DateFormat("H:00").format(_selectedDate)),
                  Row(
                    children: [
                      Expanded(
                        child: FlatButton(
                          child: Text("Zmień datę"),
                          onPressed: () => _selectDate(),
                        ),
                      ),
                      Expanded(
                        child: FlatButton(
                          child: Text("Zmienić czas"),
                          onPressed: () => _selectTime(),
                        ),
                      ),
                    ],
                  ),
                  RaisedButton(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 100),
                      child: Text(
                        "Stwórz",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    onPressed: () {
                      EventModel event = EventModel();
                      if (_eventNameController.text == "") {
                        addEventKey.currentState.showSnackBar(SnackBar(
                          content: Text("Musisz dodać nazwę wydarzenia"),
                        ));
                      } else if (_authorController.text == "") {
                        addEventKey.currentState.showSnackBar(SnackBar(
                          content: Text("Musisz dodać autora"),
                        ));
                      } else if (_lengthController.text == "") {
                        addEventKey.currentState.showSnackBar(SnackBar(
                          content: Text("Musisz dodać długość wydarzenia"),
                        ));
                      } else {
                        event.name = _eventNameController.text;
                        event.author = _authorController.text;
                        event.length = int.parse(_lengthController.text);
                        event.dateCompleted = Timestamp.fromDate(_selectedDate);

                        _addEvent(context,widget.currentUser, widget.groupName, event);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}