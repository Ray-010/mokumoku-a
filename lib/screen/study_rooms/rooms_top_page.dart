import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mokumoku_a/menu/drawer.dart';
import 'package:mokumoku_a/screen/study_rooms/add_study_room.dart';
import 'package:mokumoku_a/screen/study_rooms/study_page.dart';
import 'package:mokumoku_a/screen/study_rooms/study_room_ui/study_room_01.dart';
import 'package:mokumoku_a/screen/study_rooms/study_room_ui/study_room_02.dart';
import 'package:mokumoku_a/screen/study_rooms/study_room_ui/study_room_03.dart';
import 'package:mokumoku_a/utils/firebase.dart';

class RoomsTopPage extends StatefulWidget {
  final uid;
  RoomsTopPage(this.uid);

  @override
  _RoomsTopPageState createState() => _RoomsTopPageState();
}

class _RoomsTopPageState extends State<RoomsTopPage> {

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

        return Scaffold(
          appBar: AppBar(
            actions: [
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
            title: Text(
              '勉強部屋',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),

          drawer: DrawerPage(widget.uid),

          body: Center(
            // ゆるゆる部屋
            child: ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

                return Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(
                        color: Colors.grey,
                        width: 1.0, // Underline thickness
                      ))
                  ),
                  child: ListTile(
                    // 部屋のタイトル
                    title: Container(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        data['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
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
                      if (data['title'] == 'ルーム1') {
                        // // ルーム1部屋
                        // Firestore.addUsers(document.id, widget.uid).then((_) {
                        //   Navigator.push(context, MaterialPageRoute(
                        //     builder: (context) => StudyRoom01(data['title'], data['finishedTime'].toDate(), document.id, widget.uid),
                        //   ));
                        // });

                        // ルーム3部屋
                        Firestore.addUsers(document.id, widget.uid).then((_) {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => StudyRoom03(data['title'], data['finishedTime'].toDate(), document.id, widget.uid),
                          ));
                        });
                      } else if (data['title'] == 'ルーム2') {
                        // ルーム1部屋
                        Firestore.addUsers(document.id, widget.uid).then((_) {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => StudyRoom02(data['title'], data['finishedTime'].toDate(), document.id, widget.uid),
                          ));
                        });
                      } else {
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
        );
      }
    );
  }
}