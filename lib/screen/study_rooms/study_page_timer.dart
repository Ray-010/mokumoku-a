import 'package:flutter/material.dart';
import 'package:mokumoku_a/screen/study_rooms/timer_model.dart';
import 'package:provider/provider.dart';

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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(
                          color: Colors.grey,
                          width: 5.0, // Underline thickness
                        ))
                    ),
                    child: Text(
                      model.timeToDisplay,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 3.0,
                      ),
                    ),
                  ),
                ),

                // テキスト形式ボタン
                // ElevatedButton(
                //   onPressed: (){
                //     model.started ? model.startTimer() : model.stopTimer();
                //   },
                //   style: ElevatedButton.styleFrom(
                //     primary: model.started ? Colors.green : Colors.red,
                //     minimumSize: Size(100, 40),
                //   ),
                //   child: Text(
                //     model.started ? 'START' : 'STOP',
                //     style: TextStyle(
                //       fontWeight: FontWeight.bold,
                //       fontSize: 20,
                //     ),
                //   ),
                // ),

                // アイコンボタン形式
                IconButton(
                  onPressed: (){
                    model.started ? model.startTimer() : model.stopTimer();
                  },
                  iconSize: 50,
                  color: model.started ? Colors.green : Colors.red,
                  icon: Icon(model.started ? Icons.play_circle_fill : Icons.pause_circle_filled),
                ),
              ],
            ),
          );

          //   GestureDetector(
          //   onTap: () {
          //     model.started ? model.startTimer() : model.stopTimer();
          //   },
          //   child: Container(
          //     padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          //     decoration: BoxDecoration(
          //       color:  model.started ? Colors.red[100] : Colors.white,
          //       borderRadius: BorderRadius.circular(15.0),
          //       border: model.started ? Border.all(color: Colors.red, width: 5.0) : Border.all(color: Colors.green, width: 5.0),
          //     ),
          //     child: Text(
          //       model.timeToDisplay,
          //       style: TextStyle(
          //         fontSize: 30.0,
          //         fontWeight: FontWeight.w600,
          //         color: model.started ? Colors.black : Colors.green,
          //       ),
          //     ),
          //   ),
          // );
        }
      ),
    );
  }
}