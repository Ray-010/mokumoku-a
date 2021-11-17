import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  String id;
  String title;
  int members;

  Room(this.id, this.title, this.members);
}