
import 'package:fire_station_inz_app/models/eventModel.dart';
import 'package:fire_station_inz_app/screens/reviewHistory/reviewHistory.dart';
import 'package:fire_station_inz_app/widgets/shadowContainer.dart';
import 'package:flutter/material.dart';

class EachBook extends StatelessWidget {
  final EventModel book;
  final String groupId;

  void _goToReviewHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewHistory(
          groupId: groupId,
          bookId: book.id,
        ),
      ),
    );
  }

  EachBook({this.book, this.groupId});
  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: Column(
        children: [
          Text(
            book.name,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            book.author,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          RaisedButton(
            child: Text("Reviews"),
            onPressed: () => _goToReviewHistory(context),
          )
        ],
      ),
    );
  }
}