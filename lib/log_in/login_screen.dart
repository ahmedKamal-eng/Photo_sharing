
import 'package:flutter/material.dart';
import 'package:photo_sharing_app/log_in/components/heading_text.dart';
import 'package:photo_sharing_app/log_in/components/info.dart';

class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
        color: Color(0xff00d2d3)

        // gradient: LinearGradient(
        //   colors: [Colors.deepOrange.shade400,Colors.deepOrange.shade900],
        //   begin: Alignment.centerLeft,
        //   end: Alignment.centerRight,
        //   stops: const [0.2,0.9]
        // ),

      ),

      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                HeadText(),
                Credentials()
              ],
            ),
          ),
        ),
      ),

    );
  }
}
