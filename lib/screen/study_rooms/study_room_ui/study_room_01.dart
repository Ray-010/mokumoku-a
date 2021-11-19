import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mokumoku_a/screen/study_rooms/rooms_top_page.dart';
import 'package:mokumoku_a/screen/study_rooms/study_room_ui/timer_01.dart';
import 'package:mokumoku_a/utils/firebase.dart';
import 'package:intl/intl.dart' as intl;

// Room01部屋
// TODO：ターゲット層が大学生＝ポップよりおしゃれな感じにしたい
class StudyRoom01 extends StatefulWidget {
  final String title;
  final String documentId;
  final String myUid;
  final String initialMessage;
  final String progressMessage;
  final String lastMessage;
  final int color;
  final int imageIndex;

  StudyRoom01(this.title, this.documentId, this.myUid, this.initialMessage, this.progressMessage, this.lastMessage, this.color, this.imageIndex);


  @override
  _StudyRoom01State createState() => _StudyRoom01State();
}

class _StudyRoom01State extends State<StudyRoom01> {

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

  _showAlertDialog(context) {
    return showDialog<void>(
      context: context, 
      barrierDismissible: true, // ダイアログ外側をタップして閉じる
      useSafeArea: true,
      builder: (context) {
        return AlertDialog(
          title: Text('本当に退出しますか？'),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              child: Text(
                'キャンセル',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              )
            ),
            TextButton(
              onPressed: () async{
                await Firestore.sendMessage(widget.documentId, widget.myUid, widget.lastMessage, widget.color, widget.imageIndex);
                await Firestore.getOutRoom(widget.documentId, widget.myUid);
                await Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => RoomsTopPage(widget.myUid),
                ));
              }, 
              child: Text(
                '退出',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              )
            ),
          ],
        );
      }
    );
  }

  @override
  void initState() {
    Firestore.sendMessage(widget.documentId, widget.myUid, widget.initialMessage, widget.color, widget.imageIndex);
    super.initState();
  }

  @override
  Future<void> dispose() async {
    Firestore.sendMessage(widget.documentId, widget.myUid, widget.lastMessage, widget.color, widget.imageIndex);
    Firestore.getOutRoom(widget.documentId, widget.myUid);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title:  Text(
          widget.title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          iconSize: 28.0,
          color: Colors.black,
          onPressed: (){
            _showAlertDialog(context);
          }, 
        ),
      ),

      body: Column(
        children: [

          // 滞在時間が長いランキング上位10名表示
          Container(
            height: 80,
            padding: EdgeInsets.only(top:10.0),
            child: Column(
              children: [
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
                        height: 70,
                        padding: EdgeInsets.only(bottom: 10.0),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(
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
                                  padding: EdgeInsets.only(left: 3.0, top: 5),
                                  alignment: Alignment.topCenter,
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage(imagesList[data['imageIndex']]),
                                    backgroundColor: colorsList[data['color']],
                                    radius: 30,
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
          StudyPageTimer01(widget.documentId, widget.myUid, widget.color, widget.imageIndex,widget.progressMessage),

          // タイムライン
          Container(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'TIMELINE',
              style: TextStyle(
                letterSpacing: 2.0,
                fontSize: 16,
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
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(
                        color: Colors.grey,
                        width: 1.0, // Underline thickness
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
          color: Colors.black26,
          width: 1.0,
        )),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // アイコン
          Container(
            width: 60,
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            alignment: Alignment.topCenter,
            child: CircleAvatar(
              backgroundImage: AssetImage(imagesList[data['imageIndex']]),
              backgroundColor: colorsList[data['color']],
              radius: 20,
            ),
          ),

          // メッセージ
          Container(
            width: MediaQuery.of(context).size.width - 110,
            padding: EdgeInsets.only(left: 3.0),

            child: Text(
              data['message'],
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),

          // 時間
          Container(
            width: 40,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 5),
            child: Column(
              children: [
                Text(
                  intl.DateFormat('MM/dd').format(data['createdAt'].toDate().add(Duration(hours: 9))),
                  style: TextStyle(
                    fontSize: 12,
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
          ),
        ],
      ),
    );
  }
}