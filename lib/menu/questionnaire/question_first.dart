import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mokumoku_a/menu/questionnaire/question_first_model.dart';
import 'package:provider/provider.dart';

class QuestionFirstPage extends StatelessWidget {
  double _progress = 0.2;

  SingingCharacter? _character;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<QuestionFirstModel>(
      create: (_) => QuestionFirstModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('アンケート1'),
        ),
        body: Column(
          children: [
            Container(
              color: Colors.grey[300],
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Text(
                      '1/5',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue,
                      ),
                    ),
                  ),

                  // プログレスバー
                  Padding(
                    padding: const EdgeInsets.only(right: 30.0, left: 30.0, top: 5.0, bottom: 20.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.white,
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.lightBlue),
                        minHeight: 30,
                        value: _progress,
                      ),
                    ),
                  ),

                ],
              ),
            ),

            // 質問内容
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.width * 0.2,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.lightBlue,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Q1',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        '当てはまる性別を教えてください',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),


            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Consumer<QuestionFirstModel>(builder: (context, model, child) {
                SingingCharacter? _character = model.character;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                      child: Container(
                        child: RadioListTile<SingingCharacter>(
                          title: const Text('男性'),
                          activeColor: Colors.lightBlue,
                          value: SingingCharacter.first,
                          groupValue: _character,
                          onChanged: (SingingCharacter? value) {
                            model.setSelected(value);
                          },
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 3,
                            color: model.character == SingingCharacter.first ? Colors.lightBlue : Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                      child: Container(
                        child: RadioListTile<SingingCharacter>(
                          title: const Text('女性'),
                          activeColor: Colors.lightBlue,
                          value: SingingCharacter.second,
                          groupValue: _character,
                          onChanged: (SingingCharacter? value) {
                            model.setSelected(value);
                          },
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 3,
                            color: model.character == SingingCharacter.second ? Colors.lightBlue : Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                      child: Container(
                        child: RadioListTile<SingingCharacter>(
                          title: const Text('回答しない'),
                          activeColor: Colors.lightBlue,
                          value: SingingCharacter.third,
                          groupValue: _character,
                          onChanged: (SingingCharacter? value) {
                            model.setSelected(value);
                          },
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 3,
                            color: model.character == SingingCharacter.third ? Colors.lightBlue : Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),


                    // ボタン
                    ElevatedButton(
                        child: Text('次へ'),
                        onPressed: () {
                          if (_character == SingingCharacter.first) {
                            print('男性');
                            model.updateFirstQuestion(1, 0);

                            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => QuestionSecondPage()));
                          } else if (_character == SingingCharacter.second) {
                            print('女性');
                            model.updateFirstQuestion(0, 1);
                            // model.updateFirstQuestion(0, 1);
                          } else if (_character == SingingCharacter.third){
                            print('回答しない');
                          } else {
                            print('未選択：何も起きない');
                          }
                        }
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
//
// class QuestionFirstPage extends StatefulWidget {
//   const QuestionFirstPage({Key? key}) : super(key: key);
//
//   @override
//   _QuestionFirstPageState createState() => _QuestionFirstPageState();
// }
//
// enum SingingCharacter { first, second, third }
//
// class _QuestionFirstPageState extends State<QuestionFirstPage> {
//
//   double _progress = 0.2;
//
//   SingingCharacter? _character;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('アンケート1'),
//       ),
//
//       body: Column(
//         children: <Widget>[
//
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 15.0),
//             child: Text(
//               '1/5',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.lightBlue,
//               ),
//             ),
//           ),
//
//           // プログレスバー
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15.0),
//             child: ClipRRect(
//               borderRadius: BorderRadius.all(Radius.circular(30)),
//               child: LinearProgressIndicator(
//                 backgroundColor: Colors.grey,
//                 valueColor: new AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
//                 minHeight: 30,
//                 value: _progress,
//               ),
//             ),
//           ),
//
//           Padding(
//             padding: const EdgeInsets.all(15.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   flex: 1,
//                   child: Padding(
//                     padding: const EdgeInsets.only(right: 8.0),
//                     child: Container(
//                       width: MediaQuery.of(context).size.width * 0.2,
//                       height: MediaQuery.of(context).size.width * 0.2,
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.lightBlue,
//                       ),
//                       alignment: Alignment.center,
//                       child: Text(
//                         'Q1',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 Expanded(
//                   flex: 3,
//                   child: Container(
//                     child: Text(
//                       '当てはまる性別を教えてください',
//                       style: TextStyle(
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           RadioListTile<SingingCharacter>(
//             title: const Text('男性'),
//             value: SingingCharacter.first,
//             groupValue: _character,
//             onChanged: (SingingCharacter? value) {
//               setState(() {
//                 _character = value;
//               });
//             },
//           ),
//           RadioListTile<SingingCharacter>(
//             title: const Text('女性'),
//             value: SingingCharacter.second,
//             groupValue: _character,
//             onChanged: (SingingCharacter? value) {
//               setState(() {
//                 _character = value;
//               });
//             },
//           ),
//           RadioListTile<SingingCharacter>(
//             title: const Text('回答しない'),
//             value: SingingCharacter.third,
//             groupValue: _character,
//             onChanged: (SingingCharacter? value) {
//               setState(() {
//                 _character = value;
//               });
//             },
//           ),
//
//           // ボタン
//           ElevatedButton(
//               child: Text('次へ'),
//               onPressed: () {
//                 if (_character == SingingCharacter.first) {
//
//                   // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => QuestionSecondPage()));
//                 } else if (_character == SingingCharacter.second) {
//
//                 } else {
//                   print('未選択：何も起きない');
//                 }
//               }
//           ),
//         ],
//       ),
//     );
//   }
// }
