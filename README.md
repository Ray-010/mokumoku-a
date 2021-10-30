# MokuMoku
demo動画↓

https://www.youtube.com/watch?v=Xfhc3wx_qls

<img src="https://user-images.githubusercontent.com/81545827/139521180-7a273330-ac8b-4257-9d4b-2c01093529c3.png" width="300">

### リポジトリ

[JPHACKS以前に開発していたリポジトリ MokuMoku](https://github.com/Ray-010/mokumoku)

差分はREADMEの下記に記載しています。

## 製品概要
### 背景(製品開発のきっかけ、課題等）
勉強を効率化するにはいくつか方法があります。例えば以下です。
- カフェや図書館等で勉強
- 友達と一緒に勉強

上記の共通点はピアプレッシャーを得ることによる勉強の効率化を目的としています。ですがこれらには以下の問題が存在します。
- コロナ下なのでカフェや図書館等、外で勉強したくない
- 人と一緒に勉強したいが友達とやるとついつい喋ってしまう

これらの問題を解決するために、具体的にはピアプレッシャーを簡単に家でも得られるようなアプリを開発をしました。

ピアプレッシャー：仲間からの圧力

### 製品説明（具体的な製品の説明）
#### コンセプト 「世界中の人と一緒にMokuMoku勉強する」
オンライン上で簡単に誰かと一緒にMokuMoku勉強できる場所を提供します。
アプリを起動し、部屋に入ることで今すぐ世界中のみんなとMokuMokuしよう！

### 特長
#### 1.  誰でも簡単に始められる
アカウント登録に個人情報は必要なくアプリをダウンロードすればすぐに始められます。

#### 2. チャットなしのチャット機能
人と一緒に勉強していることを実感するにはコミュニケーションツールが必要です。ですがチャット機能をつけてしまうとLINEのようになってしまい勉強に集中することができなくなってしまいます。そこであらかじめメッセージ内容を設定しておき、入退出、一定時間の経過等のアクション時に設定したメッセージをシステム側で送信することで、チャットをすることなくチャットをする仕組みを開発しました。

### 今後の展望
#### α版リリース
一緒に勉強している感覚をより生み出すために、いいね機能とそれによるエフェクト等を実装する。
今開発しているα版を微調整して年内にリリースをする予定。

#### MokuMoku正式リリース
α版リリース後、ユーザの声を反映し改善を加えて完成させる。

#### Android, iOS, ブラウザ版開発
より多くの人に利用してもらうために、あらゆる媒体に対応させる。

### 注力したこと（こだわり等）
- 無駄な情報の取得、再描画を無くす
  
  勉強部屋に関して、もともとはユーザが入出するたびに情報を再度取得、再描画をするというとても効率の悪いコードでした。そこで部屋にいる上位10名のユーザと最新のメッセージ最大30個を監視して、それらの情報に変更があった場合、その変更のみを反映するよう改善しました。
- 他ユーザと一緒に勉強している感覚を生み、且つ集中しやすい環境を作る

  これを実現するために独自のチャット機能を開発しました。人と一緒に勉強していることを実感するにはコミュニケーションツールが必要です。ですが勉強中にチャットをいじる行為は集中力 が切れてしまうと考えました。そこで我々が考えたのは、あらかじめメッセージを設定し、入退出などのアクション時にそのメッセージを送信する仕組みを開発しました。

## この1週間で開発したこと(差分)
開発した機能：
- 簡単なログイン - カラー選択

  ログインには自身のアイコンカラーを選択していただくだけでログインができます。
  またログイン時にチャット機能で利用するメッセージをランダムに持たせます。(後で変更可)
- ログイン記憶

  SharedPreferencesによるログイン情報を端末に保存することで再ログインの必要性を無くしました。
- チャット機能

  詳しいことは特徴②にあります。
- ランキング
- タイマー
- Menu (アンケート, 設定)

その他：
- イラスト ロゴとアイコン
- 全体的なUI(特に勉強部屋)

## 開発技術

### 活用した技術
* Dart
* Firebase

#### フレームワーク・ライブラリ・モジュール
* Flutter

#### デバイス
* Android

