
import 'package:fire_station_inz_app/models/authModel.dart';
import 'package:fire_station_inz_app/models/groupModel.dart';
import 'package:fire_station_inz_app/models/userModel.dart';
import 'package:fire_station_inz_app/screens/inGroup/inGroup.dart';
import 'package:fire_station_inz_app/screens/inGroup/userList.dart';
import 'package:fire_station_inz_app/screens/root/root.dart';
import 'package:fire_station_inz_app/services/dbFuture.dart';
import 'package:fire_station_inz_app/widgets/shadowContainer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Rank extends StatefulWidget {

  final UserModel userRank;
  final bool boolRank;

  Rank({@required this.userRank, this.boolRank});
  @override
  _RankState createState() => _RankState();


}

class _RankState extends State<Rank> {
  final rankKey = GlobalKey<ScaffoldState>();
  TextEditingController _reviewController = TextEditingController();
  String _dropdownValue;
  AuthModel _authModel;


  @override
  void didChangeDependencies() {
    _authModel = Provider.of<AuthModel>(context);
    print(widget.userRank.groupId);
    super.didChangeDependencies();
  }
  void _UserList(){
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
                      Text("Nadaj range"),
                      DropdownButton<String>(
                        value: _dropdownValue,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(
                            color: Theme.of(context).accentColor),
                        underline: Container(
                          height: 2,
                          color: Colors.black,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            _dropdownValue = newValue;
                          });
                        },
                        items: <String>["Strażak","Starszy strażak","Dowódca"]
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  // TextFormField(
                  //   controller: _reviewController,
                  //   maxLines: 6,
                  //   decoration: InputDecoration(
                  //     hintText: "Dodać recenzję",
                  //   ),
                  // ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 80),
                      child: Text(
                        "Dodaj",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (_dropdownValue != null) {
                        DBFuture().addRank(widget.userRank.uid, _dropdownValue);
                        print(widget.userRank.uid);
                        print(_dropdownValue);
                        print(widget.userRank.groupId);
                        // finishedEvent(
                        //     widget.groupModel.id,
                        //     widget.groupModel.currentEventId,
                        //     _authModel.uid,
                        //     _dropdownValue,
                        //     _reviewController.text);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OurRoot(
                              
                            ),
                          ),
                              (route) => false,
                        );
                      } else {
                        rankKey.currentState.showSnackBar(SnackBar(
                          content: Text("Musisz dodać rangę!"),
                        ));
                      }
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