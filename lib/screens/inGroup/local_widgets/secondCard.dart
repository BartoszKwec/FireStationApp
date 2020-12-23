
import 'package:fire_station_inz_app/models/eventModel.dart';
import 'package:fire_station_inz_app/models/groupModel.dart';
import 'package:fire_station_inz_app/models/userModel.dart';
import 'package:fire_station_inz_app/screens/addEvent/addEvent.dart';
import 'package:fire_station_inz_app/services/dbFuture.dart';
import 'package:fire_station_inz_app/widgets/shadowContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SecondCard extends StatefulWidget {
  @override
  _SecondCardState createState() => _SecondCardState();
}

class _SecondCardState extends State<SecondCard> {
  GroupModel _groupModel;
  UserModel _currentUser;
  UserModel _pickingUser;
  EventModel _nextEvent;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _groupModel = Provider.of<GroupModel>(context);
    _currentUser = Provider.of<UserModel>(context);
    if (_groupModel != null) {
      _pickingUser = await DBFuture()
          .getUser(_groupModel.members[_groupModel.indexPickingEvent]);
      if (_groupModel.nextEventId != "waiting") {
        _nextEvent = await DBFuture()
            .getCurrentEvent(_groupModel.id, _groupModel.nextEventId);
      }

      if (this.mounted) {
        setState(() {});
      }
    }
  }

  void _goToAddEvent(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OurAddEvent(
          onGroupCreation: false,
          onError: false,
          currentUser: _currentUser,
        ),
      ),
    );
  }

  Widget _displayText() {
    Widget retVal;

    if (_pickingUser != null) {
      if (_groupModel.nextEventId == "waiting") {
        if (_pickingUser.uid == _currentUser.uid) {
          retVal = RaisedButton(
            child: Text("Wybierz następne wydarzenie"),
            onPressed: () {
              _goToAddEvent(context);
            },
          );
        } else {
          retVal = Text(
            "Czekąjąc aż " + _pickingUser.fullName + " utworzy wydarzenie.",
            style: TextStyle(
              fontSize: 30,
              color: Colors.grey[600],
            ),
          );
        }
      } else {
        retVal = Column(
          children: [
            Text(
              "Nastepne wydarzenie jest:",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              (_nextEvent != null) ? _nextEvent.name : "ładowanie..",
              style: TextStyle(
                fontSize: 30,
                color: Colors.grey[600],
              ),
            ),
            Text(
              (_nextEvent != null) ? _nextEvent.author : "ładowanie..",
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[600],
              ),
            ),
          ],
        );
      }
    } else {
      retVal = Text(
        "ładowanie...",
        style: TextStyle(
          fontSize: 30,
          color: Colors.grey[600],
        ),
      );
    }

    return retVal;
  }

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: _displayText(),
      ),
    );
  }
}