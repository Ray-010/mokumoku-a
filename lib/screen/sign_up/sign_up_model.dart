import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mokumoku_a/utils/shared_prefs.dart';

class SignUpModel extends ChangeNotifier {
  final color = 'blue';

  Future signUp() async {
    print('in signup');
    final doc = FirebaseFirestore.instance.collection('users').doc();
    await doc.set({
      'color': color,
      'createdAt': Timestamp.now(),
    });
    await SharedPrefs.setUid(doc.id);
  }
}