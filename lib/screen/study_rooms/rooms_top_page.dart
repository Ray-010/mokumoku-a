import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mokumoku_a/menu/drawer.dart';
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[300],
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'MokuMoku',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 5.0,
          ),
        ),
      ),
      drawer: DrawerPage(widget.uid),

      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0,),
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0,),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black12,

              ),
              borderRadius: BorderRadius.circular(5.0,),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(width: 30.0,),
                Container(
                  child: Image(
                    width: 50,
                    image: AssetImage('images/enter_room.png'),
                    color: Theme.of(context).primaryColor,

                  ),
                ),
                SizedBox(width: 20.0,),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '部屋を選ぼう！',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                        ),
                      ),
                      SizedBox(height: 5.0,),
                      Text(
                        '※内装が違うだけで部屋に違いはありません',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.black54
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.roomRef
                .orderBy('order')
                .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            
                    return GestureDetector(
                      onTap: () {
                        Firestore.getUsersMessages(widget.uid).then((messages) {
                          if (data['title'] == 'Room01') {
                            Firestore.addUsers(document.id, widget.uid).then((_) {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => StudyRoom01(data['title'], document.id, widget.uid, messages.initialMessage, messages.progressMessage, messages.lastMessage, messages.color, messages.imageIndex),
                              ));
                            });
                          } else if (data['title'] == 'Room02') {
                            Firestore.addUsers(document.id, widget.uid).then((_) {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => StudyRoom02(data['title'], document.id, widget.uid, messages.initialMessage, messages.progressMessage, messages.lastMessage, messages.color, messages.imageIndex),
                              ));
                            });
                          } else if (data['title'] == 'Room03') {
                            Firestore.addUsers(document.id, widget.uid).then((_) {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => StudyRoom03(data['title'], document.id, widget.uid, messages.initialMessage, messages.progressMessage, messages.lastMessage, messages.color, messages.imageIndex,
                              )));
                            });
                          } else {
                            Firestore.addUsers(document.id, widget.uid).then((_) {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => StudyPage(data['title'], document.id, widget.uid, messages.initialMessage, messages.progressMessage, messages.lastMessage, messages.color, messages.imageIndex)
                              ));
                            });
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0,),
                        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0,),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black12
                          ),
                          borderRadius: BorderRadius.circular(5.0,),
                        ),
                        child: ListTile(
                          // 部屋のタイトル
                          leading: Container(
                            width: 50,
                            child: Image(
                              image: AssetImage('images/${data['icon']}.png'),
                              // color: Theme.of(context).primaryColor,
                            ),
                          ),
                          title: Container(
                            margin: EdgeInsets.only(left: 30.0),
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
                        ),
                      ),
                    );
                  }).toList(),
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}