import 'package:flutter/material.dart';

class AboutMokuMokuPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MokuMokuについて'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  'MokuMokuとは？',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '1人で勉強するとどうしても集中が続かなかったり、'
                'コロナ禍で図書館やカフェに行きにくくなってしまったり、'
                '友だちと集まって作業するとついつい話過ぎてしまったり…。'
                'そんな経験ありませんか？'
                'これらのお悩みを解決するアプリがMokuMokuです。'
                '「皆で一緒に黙々集中して勉強できる」ネットの自習室を実現しました。\n',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '使い方',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '①好きな勉強部屋を選択\n'
                    '②入室したらタイマーをスタート\n'
                    '③皆でMokuMoku勉強しよう！\n',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '勉強部屋',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '部屋ごとにデザインが異なります。'
                'また、入室しただけではタイマーは動かないので、必ずスタートさせてください。\n',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  'メッセージ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '入退室や一定の時間が経つと自動的に送信されます。'
                    'メッセージの変更は勉強部屋内では出来ません。'
                    '「設定」から変更可能です。\n',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  'アイコン',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '全6種ランダムに決定します。カラーは「設定」からいつでも変更可能です。\n',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
