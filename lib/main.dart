import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mokumoku_a/screen/home.dart';
import 'package:mokumoku_a/utils/shared_prefs.dart';

Future<void> main() async {  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPrefs.setInstance();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor:Colors.lightBlue[300],
        accentColor: Colors.lightBlue[100],
      ),
      home: HomeScreen(),
    );
  }
}