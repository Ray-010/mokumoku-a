import 'package:flutter/material.dart';
import 'package:mokumoku_a/menu/questionnaire/question_first.dart';
import 'package:mokumoku_a/menu/setting.dart';
import 'package:mokumoku_a/menu/setting_01.dart';

class DrawerPage extends StatelessWidget {
  String uid;
  DrawerPage(this.uid);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[

          // ここにMokuMokuのメインキャラかロゴを入れる
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              image: DecorationImage(
                image: AssetImage('images/MokuMoku_logo_01.png'),
              ),
            ),
            child: null,
          ),

          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text(
              'MokuMokuについて',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            onTap: (){
              print('MokuMokuについての説明');
            },
          ),

          ListTile(
            leading: Icon(Icons.feed_outlined),
            title: Text(
              'アンケート',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            onTap: (){
              // 一旦戻れるように変更
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuestionFirstPage(),
                ),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              '設定',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            onTap: (){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => SettingPage01(uid),
              ));
              // Navigator.push(context, MaterialPageRoute(
              //   builder: (context) => SettingPage(uid),
              // ));
            },
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text(
              'シェア',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            onTap: (){
              print('SHARE');
            },
          ),
        ],
      ),
    );
  }
}
