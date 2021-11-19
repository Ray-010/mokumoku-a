import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mokumoku_a/screen/study_rooms/rooms_top_page.dart';
import 'package:mokumoku_a/screen/study_rooms/study_page_timer.dart';
import 'package:mokumoku_a/utils/firebase.dart';
import 'package:intl/intl.dart' as intl;

// 勉強部屋に入った後の画面 実際の勉強部屋
// TODO：スマホについている戻るボタンで退出すると人数がバグる
// 例：0名で入って、戻るボタンで部屋から出ると‐1名になる
// 1つの案：pushReplacement使って戻るボタンで戻れないようにしたうえで、退出するためのボタンをもっと分かりやすくするべき
class StudyPage extends StatefulWidget {
  final String title;
  final String documentId;
  final String myUid;
  final String initialMessage;
  final String progressMessage;
  final String lastMessage;
  final int color;
  final int imageIndex;

  StudyPage(this.title, this.documentId, this.myUid, this.initialMessage, this.progressMessage, this.lastMessage, this.color, this.imageIndex);


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
        bottomOpacity: 0.0,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.lightBlue[500],
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 3.0,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          iconSize: 28.0,
          color: Theme.of(context).primaryColor,
          onPressed: (){
            _showAlertDialog(context);
          }, 
        ),
      ),
      body: Column(
        children: [
          // 滞在時間が長いランキング上位10名表示
          Container(
            height: 90.0,
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
                      return Container(
                        height: 90,
                        child: Center(
                          child: CircularProgressIndicator()
                        ),
                      );
                    }
                    return Container(
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).primaryColor.withOpacity(0.5),
                            blurRadius: 3,
                            offset: Offset(0, 1),
                          ),
                        ],
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 3.0, // Underline thickness
                          ),
                        ),
                      ),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: snapshot.data!.docs.map((document) {
                          Map data = document.data()! as Map;
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 3.0),
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              backgroundImage: AssetImage(imagesList[data['imageIndex']]),
                              backgroundColor: colorsList[data['color']],
                              radius: 34,
                            ),
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
          StudyPageTimer(widget.documentId, widget.myUid, widget.color, widget.imageIndex,widget.progressMessage),

          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/2,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 3.0,),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: Text(
                      'タイムライン',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3.0,
                      ),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: Firestore.roomRef
                        .doc(widget.documentId)
                        .collection('messages')
                        .orderBy("createdAt",descending: true)
                        .limit(30)
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if(!snapshot.hasData) {
                        return Container(
                          height: 150,
                          child: Center(
                            child: CircularProgressIndicator()
                          ),
                        );
                      } 
                      return Flexible(
                        child: ListView(
                          children: snapshot.data!.docs.map((document) {
                            Map data = document.data()! as Map;
                            return _timeLineItem(data);
                          }).toList()
                        ),
                      );
                    }
                  ),
                ],
              ),
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
        color: data['uid'] == widget.myUid ? Colors.cyan[50] : Colors.white,
        border: Border(bottom: BorderSide(
          color: (Colors.grey[300])!,
          width: 3.0, // Underline thickness
        )),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // アイコン
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              alignment: Alignment.topCenter,
              child: CircleAvatar(
                backgroundImage: AssetImage(imagesList[data['imageIndex']]),
                backgroundColor: colorsList[data['color']],
                radius: 18,
              ),
            ),
            SizedBox(width: 3,),
            // メッセージ
            Flexible(
              child: Container(
                width: MediaQuery.of(context).size.width - 120,
                padding: EdgeInsets.only(left: 3.0),
                child: Text(
                  data['message'],
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(width: 3,),
            // 時間
            Container(
              child: Text(
                intl.DateFormat('HH:mm').format(data['createdAt'].toDate().add(Duration(hours: 9))),
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}