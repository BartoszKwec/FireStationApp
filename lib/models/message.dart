
import 'package:flutter/material.dart';

@immutable 
class Message {
  final String title;
  final String body;
  final injured;
  final description;
  final place;
 // final time;

  const Message({
    @required this.title,
    @required this.body,
    @required this.injured,
    @required this.description,
    @required this.place,
    //@required this.body,
  });
  
}