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
          return GestureDetector(
            onTap: () {
              model.started ? model.startTimer() : model.stopTimer();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              decoration: BoxDecoration(
                color:  model.started ? Colors.red[100] : Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                border: model.started ? Border.all(color: Colors.red, width: 5.0) : Border.all(color: Colors.green, width: 5.0),
              ),
              child: Text(
                model.timeToDisplay,
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                  color: model.started ? Colors.black : Colors.green,
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}