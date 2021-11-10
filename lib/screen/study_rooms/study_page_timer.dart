import 'package:flutter/material.dart';
import 'package:mokumoku_a/screen/study_rooms/timer_model.dart';
import 'package:provider/provider.dart';

// 勉強部屋内のタイマー表示画面
class StudyPageTimer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TimerProvider>(
      create: (_) => TimerProvider(),
      child: Consumer<TimerProvider>(
        builder: (context, model, child) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.3,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // タイマーテキスト
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(
                          color: model.started ? Colors.grey : (Colors.lightBlue[600])!,
                          width: 5.0, // Underline thickness
                        ))
                    ),
                    child: Text(
                      model.timeToDisplay,
                      style: TextStyle(
                        color: model.started ? Colors.black : Colors.lightBlue[700],
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 3.0,
                      ),
                    ),
                  ),
                ),

                // アイコンボタン形式
                IconButton(
                  onPressed: (){
                    model.started ? model.startTimer() : model.stopTimer();
                  },
                  iconSize: 50,
                  color: model.started ? Colors.grey : (Colors.lightBlue[600])!,
                  // color: Theme.of(context).primaryColor,
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