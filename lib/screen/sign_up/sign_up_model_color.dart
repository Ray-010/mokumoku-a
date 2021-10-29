import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mokumoku_a/utils/shared_prefs.dart';

class SignUpColorModel {

  static int imageIndex = Random().nextInt(6);
  static List<String> initialMessage = [
    '今から勉強開始します！',
    '時は満ちた... 勉強を始めるぜ...!',
    'おいおい皆頑張っちゃって、俺も混ぜてくれない?',
    'いくぞぉぉぉ！！！',
  ];
  static List<String> progressMessage = [
    '勉強の手が止まらねえぇ...!',
    '皆さん適度に休憩を取りましょうね',
    'MokuMoku',
    'もくもく',
    'にゃーん',
  ];

  static List<String> lastMessage = [
    '終わります！皆さんも頑張ってください!',
    '皆さん休憩は挟むんですよ。私はお先に上がらせていただきます。',
    '目標達成！...さらば！',
    'おつ～',
  ];

  static Future signUp(colorIndex) async {
    print('in signupcolor');
    final doc = FirebaseFirestore.instance.collection('users').doc();
    await doc.set({
      'color': colorIndex,
      'createdAt': Timestamp.now(),
      'imageIndex': imageIndex,
      'initialMessage': initialMessage[Random().nextInt(initialMessage.length)],
      'progressMessage': progressMessage[Random().nextInt(progressMessage.length)],
      'lastMessage': lastMessage[Random().nextInt(lastMessage.length)],
    });
    await SharedPrefs.setUid(doc.id);
  }
}