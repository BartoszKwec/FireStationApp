
import 'package:fire_station_inz_app/models/eventModel.dart';
import 'package:fire_station_inz_app/models/groupModel.dart';
import 'package:fire_station_inz_app/screens/review/review.dart';
import 'package:fire_station_inz_app/screens/reviewHistory/reviewHistory.dart';
import 'package:fire_station_inz_app/widgets/shadowContainer.dart';
import 'package:flutter/material.dart';

class EachEvent extends StatelessWidget {
  final EventModel event;
  final String groupId;
  final GroupModel group;
  

  

  void _goToReviewHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewHistory(
          groupId: groupId,
          eventId: event.id,
        ),
      ),
    );
  }
  // void _goToReview(BuildContext context){

  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => Review(
  //         groupModel: group,
          
  //       ),
  //     ),
  //   )
  // }

  EachEvent({this.event, this.groupId, this.group});
  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: Column(
        children: [
          Text(
            event.name,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            event.author,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          // RaisedButton(
          //   child: Text("Dodaj recenzje"),
          //   onPressed: () => _goToReview(context),
          // ),
          RaisedButton(
            child: Text("Wszystkie recenzje"),
            onPressed: () => _goToReviewHistory(context),
          )
        ],
      ),
    );
  }
}