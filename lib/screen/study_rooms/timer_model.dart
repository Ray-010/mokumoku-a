import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:mokumoku_a/utils/firebase.dart';

class TimerProvider extends ChangeNotifier {

  final String roomDocumentId;
  final String uid;
  final int color;
  final int imageIndex;
  final String progressMessage;
  TimerProvider(this.roomDocumentId, this.uid, this.color, this.imageIndex, this.progressMessage);

  int hour = 0;
  int min = 0;
  int sec = 0;
  bool started = true;
  bool stopped = true;
  int pauseTime = 0;
  int timeForTimer = 0;
  String timeToDisplay = '00:00:00';
  late Timer _timer;

  static const durationSec = Duration(seconds: 1);
  
  void startTimer() {
    if(stopped!=true) {
      this.timeForTimer = pauseTime;
    } else {
      this.timeForTimer = pauseTime;
    }
    started = false;
    
    _timer = Timer.periodic(durationSec, (timer) {
      if (this.stopped==false) { // 一時停止
        pauseTime = timeForTimer;
        timer.cancel();
        stopped = true;
      } else if(this.timeForTimer < 60) {
        this.timeToDisplay = '00:00:'+this.timeForTimer.toString().padLeft(2, "0");
        this.timeForTimer += 1;

        // TODO: JPHACKS用のテスト, ハッカソン終了後消去
        if(timeForTimer % 10 == 0) {
          Firestore.sendMessage(
            roomDocumentId, 
            uid, 
            "$progressMessage  --$timeForTimer秒経過", 
            color,
            imageIndex
          );
        }
        
      } else if(this.timeForTimer < 3600) {
        int m = (this.timeForTimer / 60).floor();
        int s = this.timeForTimer - (60*m);
        this.timeToDisplay = '00:' + m.toString().padLeft(2, "0") + ':' + s.toString().padLeft(2, "0");
        this.timeForTimer += 1;
        
        // 30分経過でprogressmessageを送信
        if(m==30 && s==0) {
          Firestore.sendMessage(
            roomDocumentId, 
            uid, 
            "$progressMessage  --$m分経過", 
            color,
            imageIndex
          );
        }

      } else {
        int h = (this.timeForTimer / 3600).floor();
        int t = this.timeForTimer -(3600*h);
        int m = (t / 60).floor();
        int s = t-(60*m);
        this.timeToDisplay = h.toString().padLeft(2, "0") + ':' + m.toString().padLeft(2, "0") + ':' + s.toString().padLeft(2, "0");
        this.timeForTimer += 1;

        // 30分毎経過でprogressmessageを送信
        if((m==0 || m==30) && s==0) {
          Firestore.sendMessage(
            roomDocumentId, 
            uid, 
            "$progressMessage  --$h時間$m分経過", 
            color,
            imageIndex
          );
        }
      }
      notifyListeners();
    });
  }
  void stopTimer() {
    started = true;
    stopped = false;
  }

  // なぜか機能しない。ただtimerをcancelせずに部屋を退出してもエラーを吐かない。原因不明
  @override
  void dispose() {
    try {
      _timer.cancel();
    } catch(e) {

    }
    super.dispose();
  }
}