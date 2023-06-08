
import 'package:flutter/material.dart';

import 'component/heading_text.dart';
import 'component/info.dart';

class SignUpScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  Container(

      color: Color(0xff00d2d3),

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
