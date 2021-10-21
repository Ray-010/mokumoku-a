import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mokumoku_a/utils/shared_prefs.dart';

class SignUpColorModel {

  static Future signUp(colorIndex) async {
    print('in signup');
    final doc = FirebaseFirestore.instance.collection('users').doc();
    await doc.set({
      'color': colorIndex,
      'createdAt': Timestamp.now(),
    });
    await SharedPrefs.setUid(doc.id);
  }
}