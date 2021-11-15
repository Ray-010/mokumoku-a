import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:mokumoku_a/screen/sign_up/sign_up_model.dart';
import 'package:mokumoku_a/screen/study_rooms/rooms_top_page.dart';
import 'package:mokumoku_a/utils/shared_prefs.dart';

// 初めて使用する時に表示される画面
class SignUpScreen02 extends StatefulWidget {
  const SignUpScreen02({Key? key}) : super(key: key);

  @override
  _SignUpScreen02State createState() => _SignUpScreen02State();
}

class _SignUpScreen02State extends State<SignUpScreen02> {

  // カラー選択
  bool lightTheme = true;
  Color currentColor = Colors.blue;

  void changeColor(Color color) => setState(() => currentColor = color);

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

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          width: screenWidth,
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.5 - 200,
              ),

              Container(
                height: 150,
                width: 150,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: AssetImage('images/MokuMoku_logo_02.png'),
                      fit: BoxFit.cover,
                    )
                ),
              ),

              Container(
                padding: EdgeInsets.only(bottom: 80),
                child: Text(
                  'MokuMoku',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    letterSpacing: 2.0,
                  ),
                ),
              ),

              Container(
                child: Text(
                  'アイコンカラーを設定してユーザー登録しよう！',
                  style: TextStyle(

                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 20.0, top: 10),
                child: OutlinedButton(
                  child: Container(
                    width: 200,
                    height: 50,
                    padding: EdgeInsets.all(5),
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
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    primary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: const BorderSide(),
                  ),
                  onPressed: () {
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
                ),
              ),

              ElevatedButton(
                child: Container(
                  width: 200,
                  height: 50,
                  padding: EdgeInsets.all(5),
                  alignment: Alignment.center,
                  child: Text(
                    'はじめる',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.lightBlue,
                  onPrimary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  SignUpModel.signUp(colorsList.indexOf(currentColor)).then((value) {
                    final uid = SharedPrefs.getUid();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => RoomsTopPage(uid)));
                  } );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
