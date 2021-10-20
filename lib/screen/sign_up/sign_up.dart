import 'package:flutter/material.dart';
import 'package:mokumoku_a/screen/sign_up/sign_up_model.dart';
import 'package:mokumoku_a/screen/study_rooms/rooms_top_page.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: ChangeNotifierProvider<SignUpModel>(
            create: (_)=> SignUpModel(),
            child: Consumer<SignUpModel>(
              builder: (context, model, child) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // model.color = Colors.red;
                        print('change color');
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height/2,
                        child: Center(
                          child: Text(
                            'Set Color'
                          ),
                        )
                      )
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        side: BorderSide(
                          color: Colors.blue,
                          width: 1.5,
                        )
                      ),
                      child: Text(
                        '選択',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: (){
                        model.signUp().then((value) {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => RoomsTopPage()));
                        } );
                      },
                    ),
                  ],
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}