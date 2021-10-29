import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:mokumoku_a/screen/sign_up/sign_up_model_color.dart';
import 'package:mokumoku_a/screen/study_rooms/rooms_top_page.dart';
import 'package:mokumoku_a/utils/shared_prefs.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

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
                margin: EdgeInsets.symmetric(vertical: 15.0),
                alignment: Alignment.center,
                child: Text(
                  'あなたも一緒に',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 8.0,
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

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {
                    SignUpColorModel.signUp(colorsList.indexOf(currentColor)).then((value) {
                      final uid = SharedPrefs.getUid();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => RoomsTopPage(uid)));
                    } );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
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
