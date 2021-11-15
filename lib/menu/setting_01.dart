import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:mokumoku_a/model/user.dart';
import 'package:mokumoku_a/utils/firebase.dart';

// 設定画面に来た時
class SettingPage01 extends StatefulWidget {
  final String uid;

  SettingPage01(this.uid);

  @override
  _SettingPage01State createState() => _SettingPage01State();
}

class _SettingPage01State extends State<SettingPage01> {
  // TODO：何も変更が無いとき⇒戻れる・保存ボタン押せない
  // TODO：変更したが保存していないとき⇒戻るときにダイアログ表示・保存ボタン表示
  // TODO：変更して保存した⇒戻れる・保存ボタン押せない

  String initialMessage = '';
  String progressMessage = '';
  String lastMessage = '';
  String _newinitialMessage = '';
  String _newprogressMessage = '';
  String _newlastMessage = '';
  TextEditingController _newinitialMessageController = TextEditingController();
  TextEditingController _newprogressMessageController = TextEditingController();
  TextEditingController _newlastMessageController = TextEditingController();


  bool isChanged() {
    if(_newinitialMessage=='' && _newlastMessage == '' && _newprogressMessage == '' && firstColor == currentColor) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> getMessages(String uid) async {
    Firestore.getUsersMessages(uid).then((messages) {
      setState(() {
        initialMessage = messages.initialMessage;
        progressMessage = messages.progressMessage;
        lastMessage = messages.lastMessage;
      });
    });
  }


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

  int color = 0;
  int imageIndex = 0;
  Color currentColor = Colors.blue;
  Color firstColor = Colors.blue;

  @override
  void initState() {
    // TODO：Firestoreにasyncを使いたかった
    Firestore.getProfile(widget.uid).then((user) {
      color = user.color;
      imageIndex = user.imageIndex;
    }).then((_) {
      setState(() {
        color = this.color;
        imageIndex = this.imageIndex;
        currentColor = colorsList[color];
        firstColor = colorsList[color];
      });
    });
    getMessages(widget.uid);
    super.initState();
  }

  void changeColor(Color color) => setState(() => currentColor = color);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        if (isChanged()) {
          // 変更したが保存していない内容があった場合
          return _backButtonPress(context);
        } else {
          // 何も変更していない場合
          return true;
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('設定'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 3.0, top: 5),
                  alignment: Alignment.topCenter,
                  child: CircleAvatar(
                    backgroundImage: AssetImage(imagesList[imageIndex]),
                    backgroundColor: currentColor,
                    radius: 50,
                  ),
                ),


                // カラー選択
                TextButton(
                    onPressed: (){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('SELECT COLOR'),
                            content: SingleChildScrollView(
                              child: BlockPicker(
                                pickerColor: currentColor,
                                onColorChanged: changeColor,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 3),
                            child: Icon(
                              Icons.circle,
                              color: currentColor,
                              size: 30,
                            ),
                          ),
                          Text(
                            '色選択',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 24,
                            ),
                          )
                        ],
                      ),
                    )
                ),

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

                ElevatedButton(
                  child: Container(
                    width: 200,
                    height: 50,
                    alignment: Alignment.center,
                    child: Text(
                      '保存',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: isChanged() ? () {
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
                      Firestore.updateColor(widget.uid, colorsList.indexOf(currentColor));
                      Navigator.pop(context);
                    });
                  } : null,
                ),

              ],
            ),
          )
      ),
    );
  }

  Future<bool> _backButtonPress(BuildContext context) async {
    bool? answer = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              '変更が保存されていません。変更を破棄しますか？',
              style: TextStyle(

              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('キャンセル')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('破棄する'))
            ],
          );
        });

    return answer ?? false;
  }
}