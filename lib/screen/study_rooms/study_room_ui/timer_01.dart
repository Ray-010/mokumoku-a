import 'package:flutter/material.dart';
import 'package:mokumoku_a/screen/study_rooms/timer_model.dart';
import 'package:provider/provider.dart';

// 勉強部屋内のタイマー表示画面
class StudyPageTimer01 extends StatelessWidget {
  
  final String roomDocumentId;
  final String uid;
  final int color;
  final int imageIndex;
  final String progressMessage;

  StudyPageTimer01(this.roomDocumentId, this.uid, this.color, this.imageIndex, this.progressMessage);


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TimerProvider>(
      create: (_) => TimerProvider(roomDocumentId, uid, color, imageIndex, progressMessage),
      child: Consumer<TimerProvider>(
          builder: (context, model, child) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.4,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  // タイマーテキスト
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                    child: Text(
                      model.timeToDisplay,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 3.0,
                        color: model.started ? Colors.black54 : Colors.black,
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 150,
                    height: 40,
                    child: ElevatedButton(
                      child: Text(
                        model.started ? 'START' : 'STOP',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: model.started ? Colors.lightGreen : Colors.redAccent,
                        onPrimary: Colors.white,
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () {
                        model.started ? model.startTimer() : model.stopTimer();
                      },
                    ),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }
}