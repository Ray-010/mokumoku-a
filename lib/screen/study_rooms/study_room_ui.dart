import 'package:flutter/material.dart';

class InstaHome extends StatelessWidget {
  final topBar = new AppBar(
    backgroundColor: new Color(0xfff8faf8),
    centerTitle: true,
    elevation: 1.0,
    leading: new Icon(Icons.camera_alt),
    title: Text('勉強部屋内01', style: TextStyle(color: Colors.black),),
    actions: <Widget>[
      Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: Icon(Icons.send, color: Colors.black,),
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: topBar,
        body: new InstaBody(),
    );
  }
}

class InstaBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        // Expanded(flex: 1, child: new InstaStories()),
        Flexible(child: StudyBody())
      ],
    );
  }
}

class StudyBody extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
        children: [
          new SizedBox(
            child: new InstaStories(),
            height: MediaQuery.of(context).size.height * 0.15,
          ),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text('残り'),
                Text(
                  '01：45：20',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),

          ChatList(),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 60,
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),

                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: (){
                      print('send');
                    },
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlue[100],
      height: MediaQuery.of(context).size.height * 0.6,

      child: Column(
        children: [
          Text('チャット一覧'),

          Flexible(
            child: ListView(
              // チャットっぽい感じでスクロールできる
              shrinkWrap: true,
              reverse: true,

              children: [
                ListTile(
                  title: Text('頑張りましょう！！1'),
                  leading: Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new NetworkImage(
                              "https://pbs.twimg.com/profile_images/916384996092448768/PF1TSFOE_400x400.jpg")),
                    ),
                  ),
                  onTap: (){
                  },
                ),
                ListTile(
                  title: Text('頑張りましょう！！2'),
                  leading: Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new NetworkImage(
                              "https://pbs.twimg.com/profile_images/916384996092448768/PF1TSFOE_400x400.jpg")),
                    ),
                  ),
                  onTap: (){
                  },
                ),
                ListTile(
                  title: Text('頑張りましょう！！3'),
                  leading: Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new NetworkImage(
                              "https://pbs.twimg.com/profile_images/916384996092448768/PF1TSFOE_400x400.jpg")),
                    ),
                  ),
                  onTap: (){
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InstaList extends StatefulWidget {
  @override
  _InstaListState createState() => _InstaListState();
}

class _InstaListState extends State<InstaList> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => index == 0
          ? new SizedBox(
        child: new InstaStories(),
        height: deviceSize.height * 0.15,
      )
          : Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    new Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new NetworkImage(
                                "https://pbs.twimg.com/profile_images/916384996092448768/PF1TSFOE_400x400.jpg")),
                      ),
                    ),
                    new SizedBox(
                      width: 10.0,
                    ),
                    new Text(
                      "アカウント名",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                new IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: null,
                )
              ],
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: new Image.network(
              "https://images.pexels.com/photos/672657/pexels-photo-672657.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new IconButton(
                      icon: new Icon(
                        isPressed ? Icons.favorite : Icons.favorite_border_outlined
                      ),
                      color: isPressed ? Colors.red : Colors.black,
                      onPressed: () {
                        setState(() {
                          isPressed = !isPressed;
                        });
                      },
                    ),
                    new SizedBox(
                      width: 16.0,
                    ),
                    new Icon(
                      Icons.comment,
                    ),
                    new SizedBox(
                      width: 16.0,
                    ),
                    new Icon(Icons.wallpaper),
                  ],
                ),
                new Icon(Icons.bookmark)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Liked by pawankumar, pk and 528,331 others",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: new NetworkImage(
                            "https://pbs.twimg.com/profile_images/916384996092448768/PF1TSFOE_400x400.jpg")),
                  ),
                ),
                new SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: new TextField(
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      hintText: "Add a comment...",
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child:
            Text("1 Day Ago", style: TextStyle(color: Colors.grey)),
          )
        ],
      ),
    );
  }
}

class InstaStories extends StatelessWidget {
  final topText = Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(
        "ユーザー一覧",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Text(
        "15名",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ],
  );

  final stories = Expanded(
    child: new Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: new ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 15,
        itemBuilder: (context, index) => new Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            new Container(
              width: 60.0,
              height: 60.0,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: new NetworkImage(
                        "https://pbs.twimg.com/profile_images/916384996092448768/PF1TSFOE_400x400.jpg")),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
            ),

            // 自分のものだけに＋アイコンがついている
            index == 0
                ? Positioned(
                right: 10.0,
                child: new CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  radius: 10.0,
                  child: new Icon(
                    Icons.add,
                    size: 14.0,
                    color: Colors.white,
                  ),
                ))
                : new Container()
          ],
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.all(16.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          topText,
          stories,
        ],
      ),
    );
  }
}