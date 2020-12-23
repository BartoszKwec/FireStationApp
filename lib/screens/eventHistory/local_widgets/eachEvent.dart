
import 'package:fire_station_inz_app/models/eventModel.dart';
import 'package:fire_station_inz_app/screens/reviewHistory/reviewHistory.dart';
import 'package:fire_station_inz_app/widgets/shadowContainer.dart';
import 'package:flutter/material.dart';

class EachEvent extends StatelessWidget {
  final EventModel event;
  final String groupId;

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

  EachEvent({this.event, this.groupId});
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
          RaisedButton(
            child: Text("Recenzje"),
            onPressed: () => _goToReviewHistory(context),
          )
        ],
      ),
    );
  }
}