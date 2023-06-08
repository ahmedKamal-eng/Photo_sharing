import 'package:flutter/material.dart';

class ButtonSquare extends StatelessWidget {
  final String text;
  final VoidCallback press;
  final Color color;

  ButtonSquare(
      {required this.text,
      required this.press,
      required this.color,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Container(
          width: double.infinity,
          height: 65,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color:color,
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800
              ),
            ),
          ),
        ),

      ),
    );
  }
}
