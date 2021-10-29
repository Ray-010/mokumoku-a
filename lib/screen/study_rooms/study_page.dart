import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mokumoku_a/screen/study_rooms/study_page_timer.dart';
import 'package:mokumoku_a/utils/firebase.dart';
import 'package:intl/intl.dart' as intl;

// 勉強部屋に入った後の画面 実際の勉強部屋
class StudyPage extends StatefulWidget {
  final String title;
  final DateTime finishedTime;
  final String members;
  final String documentId;
  final String myUid;

  StudyPage(this.title, this.finishedTime, this.members, this.documentId, this.myUid);

  @override
  _StudyPageState createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {

  List<Color> colorsList = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    Colors.black,
  ];

  List<String> imagesList = [
    'images/MokuMoku_alpha_icon_01.PNG',
    'images/MokuMoku_alpha_icon_02.PNG',
    'images/MokuMoku_alpha_icon_03.PNG',
    'images/MokuMoku_alpha_icon_04.PNG',
    'images/MokuMoku_alpha_icon_05.PNG',
    'images/MokuMoku_alpha_icon_06.PNG',
  ];

  String initialMessage = '';
  String progressMessage = '';
  String lastMessage = '';

  @override
  void initState() {
    Firestore.getUsersMessages(widget.myUid).then((messages) {
      initialMessage = messages.initialMessage;
      progressMessage = messages.progressMessage;
      lastMessage = messages.lastMessage;
    }).then((_) {
      Firestore.sendMessage(widget.documentId, widget.myUid, initialMessage);
    });
    super.initState();
  }

  @override
  Future<void> dispose() async {
    Firestore.sendMessage(widget.documentId, widget.myUid, lastMessage);
    Firestore.getOutRoom(widget.documentId, widget.myUid);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  RichText(
          text: TextSpan(
              children: [
                TextSpan(
                  text: '『' + widget.title + '』',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '部屋',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                  ),
                ),
              ]
          ),
        ),
      ),
      body: Column(
        children: [

          // アイコン
          Container(
            height: 100,

            child: Column(
              children: [
                Container(
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.only(left: 5),
                  child: Text('ランキング'),
                ),


                StreamBuilder<QuerySnapshot>(
                  stream: Firestore.roomRef
                      .doc(widget.documentId)
                      .collection('users')
                      .where('inRoom', isEqualTo: true)
                      .orderBy("inTime")
                      .limit(10)
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if(!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return Container(
                      height: 80,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: snapshot.data!.docs.map((document) {
                          Map data = document.data()! as Map;
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.bounceOut,
                            child: Container(
                              padding: EdgeInsets.only(left: 3.0, top: 5),
                              alignment: Alignment.topCenter,
                              child: CircleAvatar(
                                backgroundImage: AssetImage(imagesList[data['imageIndex']]),
                                backgroundColor: colorsList[data['color']],
                                radius: 40,
                              ),
                            )
                          );
                        }).toList(),
                      ),
                    );
                  }
                ),
              ],
            ),
          ),
          // タイマー
          Container(
            padding: EdgeInsets.all(20),
            child: StudyPageTimer(),
          ),

          // チャット
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.roomRef
                  .doc(widget.documentId)
                  .collection('messages')
                  .orderBy("createdAt",descending: true)
                  .limit(30)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if(!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return Container(
                  // toDo: スマホ高さの調整がまだできていない
                  height: MediaQuery.of(context).size.height-300,
                  color: Colors.lightBlueAccent[100],
                  child: ListView(
                    physics: RangeMaintainingScrollPhysics(),
                    shrinkWrap: true,
                    reverse: true,
                    children: snapshot.data!.docs.map((document) {
                      Map data = document.data()! as Map;
                      return _messagePractice(data);
                    }).toList()
                  ),
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  Widget _messagePractice(data) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,

        // 自分が送ったものは右寄せ
        textDirection: data['uid'] == widget.myUid ? TextDirection.rtl : TextDirection.ltr,

        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            alignment: Alignment.topCenter,
            child: CircleAvatar(
              backgroundImage: AssetImage(imagesList[1]),
              backgroundColor: colorsList[1],
              radius: 25,
            ),
          ),

          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),

            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),

            decoration: BoxDecoration(
              color: data['uid'] == widget.myUid ? Colors.lightBlue: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),

            child: Text(
              data['message'],
              style: TextStyle(
                fontSize: 20,
                color: data['uid'] == widget.myUid ? Colors.white : Colors.black,
              ),
            ),
          ),

          Text(
            intl.DateFormat('HH:mm').format(data['createdAt'].toDate().add(Duration(hours: 9))),
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _messageItem(data) {
    return Padding(
      padding: EdgeInsets.only(top: 5.0, right: 10, left: 10, bottom: 5),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
        decoration: BoxDecoration(
          color: data['uid'] == widget.myUid ? Colors.lightBlue: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          data['message'],
          textAlign: data['uid'] == widget.myUid ? TextAlign.right: TextAlign.left,
          style: TextStyle(
            fontSize: 18.0,
            color: data['uid'] == widget.myUid ? Colors.white : Colors.black,
            // fontWeight: FontWeight.w600
          ),
        )
      ),
    );
  }
}