import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_sharing_app/account_check/account_check.dart';
import 'package:photo_sharing_app/log_in/login_screen.dart';
import 'package:photo_sharing_app/sign_up/sign_up_screen.dart';
import 'package:photo_sharing_app/utils/my_colors.dart';
import 'package:photo_sharing_app/widgets/button_square.dart';
import 'package:photo_sharing_app/widgets/input_field.dart';

class Credentials extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              'images/forget.png',
              width: 300,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          InputField(
            hintText: 'Enter Email',
            icon: Icons.email_rounded,
            obscureText: false,
            textEditingController: _emailController,
          ),
          ButtonSquare(
              text: 'Send Link', press: () async{

                try{
                 await _auth.sendPasswordResetEmail(email:  _emailController.text);
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password reset email has been sent',style: TextStyle(fontSize: 18),),));
                }on FirebaseException catch(e)
            {
                Fluttertoast.showToast(msg: e.toString());
            }

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );

          }, color: MyColors.primary),
          TextButton(onPressed: (){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => SignUpScreen()),
            );
          }, child: Center(child: const Text('Create Account',style: TextStyle(color: MyColors.primary,fontSize: 20),)) ),
          AccountCheck(
              login: false,
              press: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              }),
        ],
      ),
    );
  }
}
