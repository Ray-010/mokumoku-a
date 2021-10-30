import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  String id;
  String title;
  int members;
  int studyTime;
  Timestamp createdTime;
  Timestamp finishedTime;
  bool roomIn;

  Room(this.id, this.title, this.members, this.createdTime, this.finishedTime, this.studyTime, this.roomIn);
}