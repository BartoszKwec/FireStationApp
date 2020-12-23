import 'dart:async';


import 'package:fire_station_inz_app/models/authModel.dart';
import 'package:fire_station_inz_app/models/eventModel.dart';
import 'package:fire_station_inz_app/models/groupModel.dart';
import 'package:fire_station_inz_app/models/userModel.dart';
import 'package:fire_station_inz_app/screens/addBook/addBook.dart';
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
  String _timeUntil = "loading...";
  AuthModel _authModel;
  bool _doneWithBook = true;
  Timer _timer;
  BookModel _currentBook;
  GroupModel _groupModel;

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (this.mounted) {
        setState(() {
          _timeUntil = TimeLeft().timeLeft(_groupModel.currentBookDue.toDate());
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
      isUserDoneWithBook();
      _currentBook = await DBFuture()
          .getCurrentBook(_groupModel.id, _groupModel.currentBookId);
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

  isUserDoneWithBook() async {
    if (await DBFuture().isUserDoneWithBook(
        _groupModel.id, _groupModel.currentBookId, _authModel.uid)) {
      _doneWithBook = true;
    } else {
      _doneWithBook = false;
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

  void _goToAddBook(BuildContext context) {
    UserModel _currentUser = Provider.of<UserModel>(context, listen: false);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OurAddBook(
          onGroupCreation: false,
          onError: true,
          currentUser: _currentUser,
        ),
      ),
    );
  }

  Widget noNextBook() {
    if (_authModel != null && _groupModel != null) {
      if (_groupModel.currentBookId == "waiting") {
        if (_authModel.uid == _groupModel.leader) {
          return Column(
            children: <Widget>[
              Text(
                "Nobody picked the next book. Leader needs to step in and pick!",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                child: Text("Pick Next Book"),
                onPressed: () => _goToAddBook(context),
                textColor: Colors.white,
              )
            ],
          );
        } else {
          return Center(
            child: Text(
              "Nobody picked the next book. Leader needs to step in and pick!",
              style: TextStyle(fontSize: 20),
            ),
          );
        }
      } else {
        return Center(
          child: Text("loading..."),
        );
      }
    } else {
      return Center(
        child: Text("loading..."),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentBook == null) {
      return ShadowContainer(child: noNextBook());
    }
    return ShadowContainer(
      child: Column(
        children: <Widget>[
          Text(
            _currentBook.name,
            style: TextStyle(
              fontSize: 30,
              color: Colors.grey[600],
            ),
          ),
          Text(
            _currentBook.author,
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
                  "Due In: ",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.grey[600],
                  ),
                ),
                Expanded(
                  child: Text(
                    _timeUntil ?? "loading...",
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
              "Finished Book",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: _doneWithBook ? null : _goToReview,
          )
        ],
      ),
    );
  }
}