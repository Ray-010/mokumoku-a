import 'package:flutter/material.dart';

class QuestionFirstPage extends StatefulWidget {
  const QuestionFirstPage({Key? key}) : super(key: key);

  @override
  _QuestionFirstPageState createState() => _QuestionFirstPageState();
}

enum SingingCharacter { first, second, third }

class _QuestionFirstPageState extends State<QuestionFirstPage> {
  double _progress = 0.2;

  SingingCharacter? _character;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('アンケート1'),
      ),

      body: Column(
        children: <Widget>[

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Text(
              '1/5',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlue,
              ),
            ),
          ),

          // プログレスバー
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey,
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                minHeight: 30,
                value: _progress,
              ),
            ),
          ),

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

          RadioListTile<SingingCharacter>(
            title: const Text('男性'),
            value: SingingCharacter.first,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
              });
            },
          ),
          RadioListTile<SingingCharacter>(
            title: const Text('女性'),
            value: SingingCharacter.second,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
              });
            },
          ),
          RadioListTile<SingingCharacter>(
            title: const Text('回答しない'),
            value: SingingCharacter.third,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
              });
            },
          ),

          // ボタン
          ElevatedButton(
              child: Text('次へ'),
              onPressed: () {
                if (_character != null) {
                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => QuestionSecondPage()));
                } else {

                }
              }
          ),
        ],
      ),
    );
  }
}
