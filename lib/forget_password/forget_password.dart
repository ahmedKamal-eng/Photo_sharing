
import 'package:flutter/material.dart';
import 'package:photo_sharing_app/forget_password/components/heading_text.dart';
import 'package:photo_sharing_app/forget_password/components/info.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff00d2d3),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
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
