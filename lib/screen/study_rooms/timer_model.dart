import 'dart:async';

import 'package:flutter/cupertino.dart';

class TimerProvider extends ChangeNotifier {
  int hour = 0;
  int min = 0;
  int sec = 0;
  bool started = true;
  bool stopped = true;
  int pauseTime = 0;
  int timeForTimer = 0;
  String timeToDisplay = '00:00:00';
  late Timer _timer;

  static const durationSec = const Duration(seconds: 1);
  
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
      } else if(this.timeForTimer < 3600) {
        int m = (this.timeForTimer / 60).floor();
        int s = this.timeForTimer - (60*m);
        this.timeToDisplay = '00:' + m.toString().padLeft(2, "0") + ':' + s.toString().padLeft(2, "0");
        this.timeForTimer += 1;
      } else {
        int h = (this.timeForTimer / 3600).floor();
        int t = this.timeForTimer -(3600*h);
        int m = (t / 60).floor();
        int s = t-(60*m);
        this.timeToDisplay = h.toString().padLeft(2, "0") + ':' + m.toString().padLeft(2, "0") + ':' + s.toString().padLeft(2, "0");
        this.timeForTimer += 1;
      }
      notifyListeners();
    });
  }
  void stopTimer() {
    started = true;
    stopped = false;
  }

  @override
  void dispose() {
    try {
      _timer.cancel();
    } catch(e) {

    }
    super.dispose();
  }
}