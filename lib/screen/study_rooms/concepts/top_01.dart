import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mokumoku_a/screen/study_rooms/study_page.dart';
import 'package:mokumoku_a/utils/firebase.dart';

class Top01 extends StatefulWidget {
  final uid;
  Top01(this.uid);

  @override
  _Top01State createState() => _Top01State();
}

class _Top01State extends State<Top01> {

  // 01
  // @override
  // Widget build(BuildContext context) {
  //   return StreamBuilder<QuerySnapshot>(
  //       stream: Firestore.roomRef
  //           .orderBy('members', descending: true)
  //           .snapshots(),
  //       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //         if (snapshot.hasError) {
  //           return Text('Something went wrong');
  //         }
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return Center(child: CircularProgressIndicator());
  //         }
  //
  //         return Scaffold(
  //           appBar: AppBar(
  //             title: Text(
  //               '勉強部屋',
  //               style: TextStyle(
  //                 color: Colors.black,
  //               ),
  //             ),
  //             centerTitle: true,
  //             backgroundColor: Colors.white,
  //           ),
  //
  //
  //           body: Center(
  //             // ゆるゆる部屋
  //             child: ListView(
  //               children: snapshot.data!.docs.map((DocumentSnapshot document) {
  //                 Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
  //
  //                 return Container(
  //                   padding: EdgeInsets.symmetric(vertical: 8),
  //                   decoration: BoxDecoration(
  //                       border: Border(bottom: BorderSide(
  //                         color: Colors.grey,
  //                         width: 1.0,
  //                       ))
  //                   ),
  //                   child: ListTile(
  //                     // 部屋のタイトル
  //                     title: Container(
  //                       padding: EdgeInsets.all(8),
  //                       child: Text(
  //                         data['title'],
  //                         style: TextStyle(
  //                           fontSize: 24,
  //                         ),
  //                       ),
  //                     ),
  //
  //                     // 何人入っているか
  //                     trailing: Container(
  //                       alignment: Alignment.center,
  //
  //                       width: MediaQuery.of(context).size.width / 5,
  //                       height: 50,
  //                       child: Row(
  //                         children: [
  //                           Icon(
  //                             Icons.perm_identity,
  //                           ),
  //
  //                           Text(
  //                             '${data['members']}名',
  //                             style: TextStyle(
  //                               fontSize: 16,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     onTap: (){
  //
  //                     },
  //                   ),
  //                 );
  //               }).toList(),
  //             ),
  //           ),
  //         );
  //       }
  //   );
  // }

  // 02
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.roomRef
            .orderBy('members', descending: true)
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
              backgroundColor: Colors.lightBlue,
              title: Text(
                '勉強部屋',
                style: TextStyle(

                ),
              ),
              centerTitle: true,
            ),


            body: Container(
              color: Colors.lightBlue[50],
              padding: EdgeInsets.all(10),
              child: ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

                  return Container(
                    padding: EdgeInsets.all(5),
                    child: Card(
                      child: ListTile(
                        // 部屋のタイトル
                        title: Container(
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                          child: Text(
                            data['title'],
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // 何人入っているか
                        trailing: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.lightBlueAccent,
                            borderRadius: BorderRadius.circular(100),
                          ),

                          width: MediaQuery.of(context).size.width / 5,
                          height: 50,
                          child: Text(
                            '${data['members']}名',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: (){

                        },
                      ),
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