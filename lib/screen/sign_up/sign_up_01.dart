import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:mokumoku_a/screen/sign_up/sign_up_model.dart';
import 'package:mokumoku_a/screen/study_rooms/rooms_top_page.dart';
import 'package:mokumoku_a/utils/shared_prefs.dart';

// 初めて使用する時に表示される画面
class SignUpScreen01 extends StatefulWidget {
  const SignUpScreen01({Key? key}) : super(key: key);

  @override
  _SignUpScreen01State createState() => _SignUpScreen01State();
}

class _SignUpScreen01State extends State<SignUpScreen01> {

  // カラー選択
  bool lightTheme = true;
  Color currentColor = Colors.blue;

  void changeColor(Color color) => setState(() => currentColor = color);
  int imageIndex = Random().nextInt(6);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 1.8,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.lightBlueAccent.withOpacity(0.7),
                    image: DecorationImage(
                      image: AssetImage('images/MokuMoku_logo_01.png'),
                      fit: BoxFit.cover,

                    )
                ),
                child: Text(
                  'MokuMoku',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 6.0,
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.topCenter,
                child: CircleAvatar(
                  backgroundImage: AssetImage(imagesList[imageIndex]),
                  backgroundColor: currentColor,
                  radius: 40,
                ),
              ),

              Container(
                alignment: Alignment.center,
                child: Text(
                  '※アイコン画像はランダムです',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
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
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.circle,
                          color: currentColor,
                          size: 30,
                        ),
                        Text(
                          'アイコンカラーを選択',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  )
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {
                    SignUpModel.signUp01(colorsList.indexOf(currentColor), imageIndex).then((value) {
                      final uid = SharedPrefs.getUid();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => RoomsTopPage(uid)));
                    } );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    width: 200,
                    alignment: Alignment.center,
                    child: Text(
                      'はじめる',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
