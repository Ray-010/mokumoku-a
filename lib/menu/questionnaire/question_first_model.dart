import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mokumoku_a/model/question.dart';


enum SingingCharacter { first, second, third }

class QuestionFirstModel extends ChangeNotifier {

  SingingCharacter? character;

  CollectionReference questions = FirebaseFirestore.instance.collection('questions');

  Future<void> updateFirstQuestion(int add_male, int add_female) async {
    final firstQuestionsData = await questions.doc('first').get();
    int male = firstQuestionsData['male'] + add_male;
    int female = firstQuestionsData['female'] + add_female;

    return await questions
        .doc('first')
        .update({'male': male, 'female': female})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  SingingCharacter? setSelected(_character) {
    character = _character;
    print('setSelected');

    notifyListeners();
  }
}