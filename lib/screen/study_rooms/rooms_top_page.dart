import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mokumoku_a/menu/questionnaire/question_first.dart';
import 'package:mokumoku_a/menu/setting.dart';
import 'package:mokumoku_a/screen/study_rooms/add_study_room.dart';
import 'package:mokumoku_a/screen/study_rooms/study_page.dart';
import 'package:mokumoku_a/utils/firebase.dart';

class RoomsTopPage extends StatefulWidget {
  final uid;
  RoomsTopPage(this.uid);

  @override
  _RoomsTopPageState createState() => _RoomsTopPageState();
}

class _RoomsTopPageState extends State<RoomsTopPage> {
  final _formKey = GlobalKey<FormState>();
  bool roomIn = true;

  Future<void> batchDelete() {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    return Firestore.roomRef.get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        var finished = document['finishedTime'].toDate().add(Duration(minutes: 30));
        var now = DateTime.now();
        var time = finished.difference(now).inSeconds;
        if (time <= 0) {
          batch.delete(document.reference);
        }
      });
      return batch.commit();
    });
  }

  @override
  void initState() {
    batchDelete();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.roomRef
          .orderBy('finishedTime', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              actions: [
                // IconButton(
                //   icon: const Icon(Icons.search),
                //   onPressed: () {
                //
                //   },
                // ),

                // プラスボタン ここから部屋を新しく作れる
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => AddStudyRoomPage(),
                        fullscreenDialog: true,
                      ));
                    },
                  ),
                ),
              ],
              // タブバー
              bottom: TabBar(
                labelColor: Colors.white,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelColor: Colors.white,
                unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                ),
                tabs: [
                  Tab(
                    text: '固定部屋',
                  ),
                  Tab(
                    text: '作成部屋',
                  ),
                ],
              ),
              title: Text(
                '勉強部屋',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),

            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[

                  // ここにMokuMokuのメインキャラかロゴを入れる
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      image: DecorationImage(
                        image: AssetImage('images/MokuMoku_logo_01.png'),
                      ),
                    ),
                    child: null,
                  ),

                  ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text(
                      'MokuMokuについて',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    onTap: (){
                      print('MokuMokuについての説明');
                    },
                  ),

                  ListTile(
                    leading: Icon(Icons.feed_outlined),
                    title: Text(
                      'アンケート',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    onTap: (){
                      // 一旦戻れるように変更
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuestionFirstPage(),
                        ),
                      );
                    },
                  ),

                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text(
                      '設定',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => SettingPage(widget.uid),
                      ));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.share),
                    title: Text(
                      'シェア',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    onTap: (){
                      print('SHARE');
                    },
                  ),
                ],
              ),
            ),

            body: TabBarView(
              children: [
                Center(
                  // ゆるゆる部屋
                  child: ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

                      // 終了後に新たに入れないようにする
                      var finished = data['finishedTime'].toDate();
                      var now = DateTime.now();
                      var time = finished.difference(now).inSeconds;
                      if (time <= 0) {
                        // 終了済み ＝ 入れない
                        roomIn = false;
                        Firestore.updateRoomIn(document.id, roomIn);
                      } else {
                        roomIn = true;
                      }

                      return Card(
                          child: ListTile(
                            tileColor: data['roomIn'] ? Colors.white : Colors.black12,
                            // 部屋のタイトル
                            title: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(
                                    color: Colors.grey,
                                    width: 1.0, // Underline thickness
                                  ))
                              ),
                              child: Text(
                                data['title'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: data['roomIn'] ? TextDecoration.none : TextDecoration.lineThrough,
                                  color: data['roomIn'] ? Colors.black : Colors.black38,
                                  fontSize: 24,
                                ),
                              ),
                            ),

                            // 時間表示
                            subtitle: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    (DateFormat("HH:mm").format(data['createdTime'].toDate().add(Duration(hours: 9))).toString()) + "~" +
                                        (DateFormat("HH:mm").format(data['finishedTime'].toDate().add(Duration(hours: 9))).toString())
                                ),
                              ),
                            ),

                            // 何人入っているか
                            trailing: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                              ),
                              width: MediaQuery.of(context).size.width / 5,
                              height: 50,
                              child: Text(
                                '${data['members']}名',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            onTap: (){
                              // roomInがTrueであれば入ることができる
                              if (data['roomIn']) {
                                // 部屋に入る人をrooms>usersにセットする
                                Firestore.addUsers(document.id, widget.uid).then((_) {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => StudyPage(data['title'], data['finishedTime'].toDate(), document.id, widget.uid),
                                  ));
                                });
                              }
                            },
                          ),
                        );
                    }).toList(),
                  ),
                ),

                Center(
                  child: ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

                      // 終了後に新たに入れないようにする
                      var finished = data['finishedTime'].toDate();
                      var now = DateTime.now();
                      var time = finished.difference(now).inSeconds;
                      if (time <= 0) {
                        // 終了済み ＝ 入れない
                        roomIn = false;
                        Firestore.updateRoomIn(document.id, roomIn);
                      } else {
                        roomIn = true;
                      }

                      return Card(
                        child: ListTile(
                          tileColor: data['roomIn'] ? Colors.white : Colors.black12,
                          // leading: FlutterLogo(size: 56.0),
                          title: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0, // Underline thickness
                                ))
                            ),
                            child: Text(
                              data['title'],
                              style: TextStyle(
                                decoration: data['roomIn'] ? TextDecoration.none : TextDecoration.lineThrough,
                                color: data['roomIn'] ? Colors.black : Colors.black38,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          subtitle: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  (DateFormat("HH:mm").format(data['createdTime'].toDate().add(Duration(hours: 9))).toString()) + "~" +
                                      (DateFormat("HH:mm").format(data['finishedTime'].toDate().add(Duration(hours: 9))).toString())
                              ),
                            ),
                          ),
                          // trailing: Icon(Icons.more_vert),
                          trailing: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                            width: MediaQuery.of(context).size.width / 4,
                            child: Text(
                              '${data['members']}名',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          onTap: (){
                            // つよつよ部屋に入れるのは目標を宣言した場合のみ
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) {
                                return Form(
                                  key: _formKey,
                                  child: AlertDialog(
                                    title: Text('『' + data['title'] + '』部屋'),
                                    content: TextFormField(
                                      maxLines: 5,
                                      // controller: titleController,
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "入室してやることを宣言しよう！",
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return '目標を記入してください';
                                        }
                                        return null;
                                      },
                                    ),
                                    actions: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    primary: Colors.white, //ボタンの背景色
                                                    side: BorderSide(
                                                      color: Colors.blue, //枠線!
                                                      width: 1, //枠線！
                                                    ),
                                                  ),
                                                  onPressed: (){
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    'キャンセル',
                                                    style: TextStyle(
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    if (data['roomIn']) {
                                                      if (_formKey.currentState!.validate()) {
                                                        await Firestore.addUsers(document.id, widget.uid);
                                                        Navigator.pop(context);
                                                        Navigator.push(context, MaterialPageRoute(
                                                          builder: (context) => StudyPage(data['title'], data['finishedTime'].toDate(), document.id, widget.uid,),
                                                        ));
                                                      }
                                                    }
                                                  },
                                                  child: Text('入室する'),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}