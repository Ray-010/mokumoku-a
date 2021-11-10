import 'package:flutter/material.dart';
import 'package:mokumoku_a/screen/study_rooms/timer_model.dart';
import 'package:provider/provider.dart';

// 勉強部屋内のタイマー表示画面
class StudyPageTimer03 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TimerProvider>(
      create: (_) => TimerProvider(),
      child: Consumer<TimerProvider>(
          builder: (context, model, child) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.5,
              // color: Colors.lightBlueAccent,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  // タイマーテキスト
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    width: MediaQuery.of(context).size.width,

                    child: Text(
                      model.timeToDisplay,
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 3.0,
                        color: model.started ? Colors.black54 : Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // アイコンボタン形式
                  IconButton(
                    onPressed: (){
                      model.started ? model.startTimer() : model.stopTimer();
                    },
                    iconSize: 50,
                    // color: Colors.white,
                    color: Colors.black,
                    icon: Icon(model.started ? Icons.play_circle_fill : Icons.pause_circle_filled),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }
}