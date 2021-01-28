
import 'package:fire_station_inz_app/screens/root/root.dart';
import 'package:fire_station_inz_app/services/auth.dart';
import 'package:fire_station_inz_app/utils/ourTheme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/authModel.dart';
import 'widgets/messaging_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AuthModel>.value(
      value: Auth().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: OurTheme().buildTheme(),
        home: OurRoot(),
      ),
      
    );
 
  }
}