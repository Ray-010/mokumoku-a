import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mokumoku_a/screen/study_rooms/study_page_timer.dart';
import 'package:mokumoku_a/utils/firebase.dart';
import 'package:intl/intl.dart' as intl;

// 勉強部屋に入った後の画面 実際の勉強部屋
class StudyPage extends StatefulWidget {
  final String title;
  final DateTime finishedTime;
  final String documentId;
  final String myUid;

  StudyPage(this.title, this.finishedTime, this.documentId, this.myUid);

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
  int color = 0;
  int imageIndex = 0;

  @override
  void initState() {
    Firestore.getUsersMessages(widget.myUid).then((messages) {
      initialMessage = messages.initialMessage;
      progressMessage = messages.progressMessage;
      lastMessage = messages.lastMessage;
      color = messages.color;
      imageIndex = messages.imageIndex;
    }).then((_) {
      Firestore.sendMessage(widget.documentId, widget.myUid, initialMessage, color, imageIndex);
    });
    super.initState();
  }

  @override
  Future<void> dispose() async {
    Firestore.sendMessage(widget.documentId, widget.myUid, lastMessage, color, imageIndex);
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
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '部屋',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ]
          ),
        ),
      ),
      body: Column(
        children: [

          // 滞在時間が長いランキング上位10名表示
          Container(
            height: 120,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    'ランキング',
                    style: TextStyle(
                      letterSpacing: 2.0,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // アイコン表示
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
                      height: 90,
                      padding: EdgeInsets.only(bottom: 10.0),
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(
                            color: Colors.grey,
                            width: 2.0, // Underline thickness
                          )),
                      ),
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
          StudyPageTimer(),

          // タイムライン
          Container(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'タイムライン',
              style: TextStyle(
                letterSpacing: 2.0,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

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
                  // color: Colors.lightBlue[100],
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(
                      color: Colors.grey,
                      width: 3.0, // Underline thickness
                    )),
                  ),
                  child: ListView(
                    children: snapshot.data!.docs.map((document) {
                      Map data = document.data()! as Map;
                      return _timeLineItem(data);
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

  // タイムライン形式
  Widget _timeLineItem(data) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),

      decoration: BoxDecoration(
        color: data['uid'] == widget.myUid ? Colors.lightBlue[50] : Colors.white,
        border: Border(bottom: BorderSide(
          color: Colors.grey,
          width: 1.0, // Underline thickness
        )),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // アイコン
          Container(
            // color: Colors.green,
            width: 70,
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            alignment: Alignment.topCenter,
            child: CircleAvatar(
              backgroundImage: AssetImage(imagesList[data['imageIndex']]),
              backgroundColor: colorsList[data['color']],
              radius: 25,
            ),
          ),

          // メッセージ
          Container(
            // color: Colors.orangeAccent,
            width: MediaQuery.of(context).size.width - 120,
            padding: EdgeInsets.only(left: 3.0),

            child: Text(
              data['message'],
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),

          // 時間
          Container(
            // color: Colors.redAccent,
            width: 50,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              intl.DateFormat('HH:mm').format(data['createdAt'].toDate().add(Duration(hours: 9))),
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}