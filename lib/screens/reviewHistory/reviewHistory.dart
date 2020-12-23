
import 'package:fire_station_inz_app/models/reviewModel.dart';
import 'package:fire_station_inz_app/services/dbFuture.dart';
import 'package:flutter/material.dart';

import 'local_widgets/eachReview.dart';

class ReviewHistory extends StatefulWidget {
  final String groupId;
  final String eventId;

  ReviewHistory({this.groupId, this.eventId});

  @override
  _ReviewHistoryState createState() => _ReviewHistoryState();
}

class _ReviewHistoryState extends State<ReviewHistory> {
  Future<List<ReviewModel>> reviews;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    reviews = DBFuture().getReviewHistory(widget.groupId, widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: reviews,
        builder: (BuildContext context, AsyncSnapshot<List<ReviewModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        BackButton(),
                      ],
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: EachReview(
                      review: snapshot.data[index - 1],
                    ),
                  );
                }
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}