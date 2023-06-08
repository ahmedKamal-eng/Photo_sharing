
import 'package:flutter/material.dart';
import 'package:photo_sharing_app/utils/my_colors.dart';

class AccountCheck extends StatelessWidget {

  final bool login;
  final VoidCallback press;

  AccountCheck({required this.login,required this.press});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(login ? "Don't have an account " : "Already have an account ",
          style:  const TextStyle(fontSize: 16,color: Colors.white),
        ),
        GestureDetector(
          onTap: press,
          child: Text(login ? "Create Account": "Log In",
            style: const TextStyle(fontSize: 16,color: MyColors.primary,fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
