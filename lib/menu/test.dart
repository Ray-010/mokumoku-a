import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future _launchUrl() async {
    var url = "https://flutter.dev/";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Unable to launch url $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WEBサイト遷移'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('WEBサイトへ遷移'),
          onPressed: () {
            _launchUrl();
          },
        ),
      ),
    );
  }
}