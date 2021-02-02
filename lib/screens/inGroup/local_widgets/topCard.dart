import 'dart:async';


import 'package:fire_station_inz_app/models/authModel.dart';
import 'package:fire_station_inz_app/models/eventModel.dart';
import 'package:fire_station_inz_app/models/groupModel.dart';
import 'package:fire_station_inz_app/models/userModel.dart';
import 'package:fire_station_inz_app/screens/addEvent/addEvent.dart';
import 'package:fire_station_inz_app/screens/review/review.dart';
import 'package:fire_station_inz_app/services/dbFuture.dart';
import 'package:fire_station_inz_app/utils/timeLeft.dart';
import 'package:fire_station_inz_app/widgets/shadowContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopCard extends StatefulWidget {
  @override
  _TopCardState createState() => _TopCardState();
}

class _TopCardState extends State<TopCard> {
  String _timeUntil = "ładowanie...";
  AuthModel _authModel;
  bool _doneWithEvent = true;
  Timer _timer;
  EventModel _currentEvent;
  GroupModel _groupModel;

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (this.mounted) {
        setState(() {
          if(_groupModel.currentEventDue!=null){
              _timeUntil = TimeLeft().timeLeft(_groupModel.currentEventDue.toDate());
          }else{
            _timer.cancel();
          }
          
        });
      }
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _authModel = Provider.of<AuthModel>(context);
    _groupModel = Provider.of<GroupModel>(context);
    if (_groupModel != null) {
      isUserDoneWithEvent();
      _currentEvent = await DBFuture()
          .getCurrentEvent(_groupModel.id, _groupModel.currentEventId);
      _startTimer();
    }
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }

  isUserDoneWithEvent() async {
    if (await DBFuture().isUserDoneWithEvent(
        _groupModel.id, _groupModel.currentEventId, _authModel.uid)) {
      _doneWithEvent = true;
    } else {
      _doneWithEvent = false;
    }
  }

  void _goToReview() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Review(
          groupModel: _groupModel,
        ),
      ),
    );
  }

  void _goToAddEvent(BuildContext context) {
    UserModel _currentUser = Provider.of<UserModel>(context, listen: false);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OurAddEvent(
          onGroupCreation: false,
          onError: true,
          currentUser: _currentUser,
        ),
      ),
    );
  }

  Widget noNextEvent() {
    if (_authModel != null && _groupModel != null) {
      if (_groupModel.currentEventId == "waiting") {
        if (_authModel.uid == _groupModel.leader) {
          return Column(
            children: <Widget>[
              Text(
                "Nikt nie wybrał następnej wydarzenie. Lider musi wkroczyć i wybrać!",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                child: Text("Wybierz następną wydarzenie"),
                onPressed: () => _goToAddEvent(context),
                textColor: Colors.white,
              )
            ],
          );
        } else {
          return Center(
            child: Text(
              "Nikt nie wybrał następnej wydarzenia. Lider musi wkroczyć i wybrać!",
              style: TextStyle(fontSize: 20),
            ),
          );
        }
      } else {
        return Center(
          child: Text("ładowanie..."),
        );
      }
    } else {
      return Center(
        child: Text("ładowanie..."),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentEvent == null) {
      return ShadowContainer(child: noNextEvent());
    }
    return ShadowContainer(
      child: Column(
        children: <Widget>[
          Text(
            _currentEvent.name,
            style: TextStyle(
              fontSize: 30,
              color: Colors.grey[600],
            ),
          ),
          Text(
            _currentEvent.author,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[600],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              children: <Widget>[
                Text(
                  "Start za: ",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.grey[600],
                  ),
                ),
                Expanded(
                  child: Text(
                    _timeUntil ?? "ładowanie...",
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          RaisedButton(
            child: Text(
              "Zakończ wydarzenie",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: _doneWithEvent ? null : _goToReview,
          )
        ],
      ),
    );
  }
}