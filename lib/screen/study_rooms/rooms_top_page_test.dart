import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mokumoku_a/screen/study_rooms/study_page.dart';
import 'package:mokumoku_a/utils/firebase.dart';

class RoomsTopPageTest extends StatefulWidget {
  final uid;
  RoomsTopPageTest(this.uid);

  @override
  _RoomsTopPageTestState createState() => _RoomsTopPageTestState();
}

class _RoomsTopPageTestState extends State<RoomsTopPageTest> {
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

        return Scaffold(
          appBar: AppBar(
            title: Text(
              '勉強部屋',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),

          body: Column(
            children: [
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0,),
                    margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).primaryColor.withOpacity(0.5),
                          blurRadius: 3,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.border_color_outlined,
                        size: 30.0,
                        color: Theme.of(context).primaryColor,
                      ),
                      
                      title: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: (Colors.grey[350])!,
                              width: 3.0,
                            ),
                          ),
                        ),
                        child: Text(
                          '前回の結果',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      subtitle: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Time：',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              Text(
                                'HH : MM',
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Date： ',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              Text(
                                'YY/MM/DD HH : MM',
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10.0,
                    right: 15.0,
                    // bottom: 10.0,
                    child: IconButton(
                      onPressed: (){
                        print('share');
                      }, 
                      icon: Icon(
                        Icons.share,
                        size: 25.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),

              Flexible(
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
                          title: Text(
                            data['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: data['roomIn'] ? TextDecoration.none : TextDecoration.lineThrough,
                              color: data['roomIn'] ? Colors.black : Colors.black38,
                              fontSize: 24,
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
                            // if (data['roomIn']) {
                            //   // 部屋に入る人をrooms>usersにセットする
                            //   Firestore.addUsers(document.id, widget.uid).then((_) {
                            //     Navigator.push(context, MaterialPageRoute(
                            //       builder: (context) => StudyPage(data['title'], document.id, widget.uid),
                            //     ));
                            //   });
                            // }
                          },
                        ),
                      );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}