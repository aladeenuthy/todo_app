import 'package:flutter/material.dart';

class Todo {
  String id;
  String title;
  String description;
  TimeOfDay startTime;
  bool completed;
  Todo({required this.id, required this.title, required this.description, required this.startTime, this.completed =false});
}
