import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_sharing_app/forget_password/forget_password.dart';
import 'package:photo_sharing_app/home_screen/home_screen.dart';
import 'package:photo_sharing_app/sign_up/sign_up_screen.dart';
import 'package:photo_sharing_app/utils/my_colors.dart';
import 'package:photo_sharing_app/widgets/button_square.dart';
import 'package:photo_sharing_app/widgets/input_field.dart';

import '../../account_check/account_check.dart';

class Credentials extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailTextController =
      TextEditingController(text: '');
  final TextEditingController _passTextController =
      TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30),
      child: Column(
        children: [
          Center(
            child: CircleAvatar(
              radius: 105,
              backgroundColor: Colors.white12,
              child: CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage('images/logo1.png'),
                backgroundColor: Color(0xff01a3a4),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          InputField(
              hintText: 'Enter Email',
              icon: Icons.email_rounded,
              obscureText: false,
              textEditingController: _emailTextController),
          InputField(
              hintText: 'Enter password',
              icon: Icons.lock,
              obscureText: true,
              textEditingController: _passTextController),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ForgetPasswordScreen()));
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: MyColors.primary,
                      width: 1,
                    ),
                    color: Colors.white24,
                  ),
                  child: Text(
                    'Forget Password',
                    style: TextStyle(
                        color: MyColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          ButtonSquare(
              text: 'Login',
              press: () async {
                try {
                  await _auth.signInWithEmailAndPassword(
                      email: _emailTextController.text.trim(),
                      password: _passTextController.text.trim());

                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => HomeScreen()));
                } catch (e) {
                  Fluttertoast.showToast(msg: e.toString());
                }
              },
              color: MyColors.primary),
          AccountCheck(
            login: true,
            press: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => SignUpScreen()));
            },
          ),
        ],
      ),
    );
  }
}
