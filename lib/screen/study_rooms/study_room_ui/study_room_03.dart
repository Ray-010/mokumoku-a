import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mokumoku_a/screen/study_rooms/study_room_ui/timer_03.dart';
import 'package:mokumoku_a/utils/firebase.dart';
import 'package:intl/intl.dart' as intl;

// Room03部屋
// TODO：新しい形を目指す。チャットはYoutubeっぽく
class StudyRoom03 extends StatefulWidget {
  final String title;
  final String documentId;
  final String myUid;
  final String initialMessage;
  final String progressMessage;
  final String lastMessage;
  final int color;
  final int imageIndex;

  StudyRoom03(this.title, this.documentId, this.myUid, this.initialMessage, this.progressMessage, this.lastMessage, this.color, this.imageIndex);


  @override
  _StudyRoom03State createState() => _StudyRoom03State();
}

class _StudyRoom03State extends State<StudyRoom03> {

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
        backgroundColor: Colors.white,
        elevation: 1.0,
        title:  Text(
          'Room03',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),

      body: Column(
        children: [

          // タイマー
          StudyPageTimer03(widget.documentId, widget.myUid, widget.color, widget.imageIndex,widget.progressMessage),

          // タイムライン
          Container(
            padding: EdgeInsets.all(3.0),
            child: Text(
              'タイムライン',
              style: TextStyle(
                letterSpacing: 2.0,
                fontSize: 20,
              ),
            ),
          ),

          // 滞在時間が長いランキング上位10名表示
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
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
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
                            padding: EdgeInsets.only(left: 5, top: 5, bottom: 5),
                            alignment: Alignment.topCenter,
                            child: CircleAvatar(
                              backgroundImage: AssetImage(imagesList[data['imageIndex']]),
                              backgroundColor: colorsList[data['color']],
                              radius: 35,
                            ),
                          )
                      );
                    }).toList(),
                  ),
                );
              }
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
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
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
      padding: EdgeInsets.symmetric(vertical: 5.0),

      decoration: BoxDecoration(
        color: data['uid'] == widget.myUid ? Colors.lightBlue[50] : Colors.white,
      ),
      child: Row(
        children: [
          // アイコン
          Container(
            width: 50,
            padding: EdgeInsets.only(left: 5.0),
            alignment: Alignment.topCenter,
            child: CircleAvatar(
              backgroundImage: AssetImage(imagesList[data['imageIndex']]),
              backgroundColor: colorsList[data['color']],
              radius: 20,
            ),
          ),

          Container(
            width: MediaQuery.of(context).size.width - 60,
            padding: EdgeInsets.only(left: 5.0),
            child: RichText(
              text: TextSpan(
                  children: [
                    TextSpan(
                      text: intl.DateFormat('HH:mm').format(data['createdAt'].toDate().add(Duration(hours: 9))),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    TextSpan(
                      text: " " + data['message'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ]
              ),
            ),
          ),
        ],
      ),
    );
  }
}