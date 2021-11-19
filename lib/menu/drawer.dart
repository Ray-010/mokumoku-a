import 'package:flutter/material.dart';
import 'package:mokumoku_a/menu/about_mokumoku.dart';
import 'package:mokumoku_a/menu/setting_01.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerPage extends StatelessWidget {
  String uid;
  DrawerPage(this.uid);

  Future _launchUrl() async {
    var url = "https://docs.google.com/forms/d/e/1FAIpQLSdo3D3qdsVj1sgccQajPFBsOV1E4vLPBduNmuSzeqqKKRT7vA/viewform";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Unable to launch url $url';
    }
  }

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
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => AboutMokuMokuPage(),
              ));
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
              Navigator.pop(context);
              _launchUrl();
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
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.share),
          //   title: Text(
          //     'シェア',
          //     style: TextStyle(
          //       fontSize: 20,
          //     ),
          //   ),
          //   onTap: (){
          //     print('SHARE');
          //   },
          // ),
        ],
      ),
    );
  }
}
