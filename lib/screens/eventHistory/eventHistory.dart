
import 'package:fire_station_inz_app/models/eventModel.dart';
import 'package:fire_station_inz_app/models/groupModel.dart';
import 'package:fire_station_inz_app/services/dbFuture.dart';
import 'package:flutter/material.dart';

import 'local_widgets/eachEvent.dart';

class EventHistory extends StatefulWidget {
  final String groupId;
  

  EventHistory({
    this.groupId,
    
  });
  @override
  _EventHistoryState createState() => _EventHistoryState();
}

class _EventHistoryState extends State<EventHistory> {
  Future<List<EventModel>> events;
  Future<GroupModel> group;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    events = DBFuture().getEventHistory(widget.groupId);
    group = DBFuture().getGroup(widget.groupId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: events,
        builder: (BuildContext context, AsyncSnapshot<List<EventModel>> snapshot) {
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
                    child: EachEvent(
                      event: snapshot.data[index - 1],
                      groupId: widget.groupId,
                      
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