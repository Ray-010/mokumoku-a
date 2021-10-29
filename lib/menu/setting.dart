import 'package:flutter/material.dart';
import 'package:mokumoku_a/utils/firebase.dart';

class SettingPage extends StatefulWidget {
  final String uid;

  SettingPage(this.uid);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  String initialMessage = '';
  String progressMessage = '';
  String lastMessage = '';
  String _newinitialMessage = '';
  String _newprogressMessage = '';
  String _newlastMessage = '';
  TextEditingController _newinitialMessageController = TextEditingController();
  TextEditingController _newprogressMessageController = TextEditingController();
  TextEditingController _newlastMessageController = TextEditingController();

  Future<void> getMessages(String uid) async {
    Firestore.getUsersMessages(uid).then((messages) {
      setState(() {
        initialMessage = messages.initialMessage;
        progressMessage = messages.progressMessage;
        lastMessage = messages.lastMessage;
      });
    });
  }

  @override
  void initState() {
    getMessages(widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('設定'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // initial message
            SizedBox(height: 20.0,),
            Text(
              '入室時メッセージ',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              child: TextFormField(
                controller: _newinitialMessageController,
                decoration: InputDecoration(
                  hintText: initialMessage,
                ),
                onChanged: (value) {
                  setState(() {
                    _newinitialMessage = value;
                  });
                },
              ),
            ),
            Text(
              '勉強中メッセージ',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              child: TextFormField(
                controller: _newprogressMessageController,
                decoration: InputDecoration(
                  hintText: progressMessage,
                ),
                onChanged: (value) {
                  setState(() {
                    _newprogressMessage = value;
                  });
                },
              ),
            ),
            Text(
              '退出時メッセージ',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              child: TextFormField(
                controller: _newlastMessageController,
                decoration: InputDecoration(
                  hintText: lastMessage
                ),
                onChanged: (value) {
                  setState(() {
                    _newlastMessage = value;
                  });
                },
              ),
            ),
            SizedBox(height: 60,),

            GestureDetector(
              onTap: () {
                if(_newinitialMessage=='') {
                  _newinitialMessage = initialMessage;
                }
                if(_newprogressMessage=='') {
                  _newprogressMessage = progressMessage;
                }
                if(_newlastMessage=='') {
                  _newlastMessage = lastMessage;
                }
                Firestore.updateMessages(widget.uid,_newinitialMessage,_newprogressMessage,_newlastMessage).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('メッセージを更新しました'),),
                  );
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                alignment: Alignment.center,
                height: 45.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.blue, width: 3.0),
                ),
                child: Text(
                  '設定',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                    letterSpacing: 2.0,
                  ),
                ) 
              ),
            ),
          ],
        ),
      )
    );
  }
}