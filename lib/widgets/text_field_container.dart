
import 'package:flutter/material.dart';

class TextFieldContainer extends StatelessWidget {

  final Widget child;
  TextFieldContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.redAccent,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10),
      margin: EdgeInsets.symmetric(vertical: 15.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white12,width: 3,),
        color: Color(0xff01a3a4),
        // gradient: LinearGradient(
        //   begin: Alignment.centerLeft,
        //   end: Alignment.centerRight,
        //   colors: [Colors.redAccent,Colors.red],
        // ),
        borderRadius: BorderRadius.circular(12),
       //  boxShadow:[
       //    BoxShadow(
       //     offset: Offset(-2,-2),
       //     spreadRadius: 1,
       //     blurRadius: 4,
       //     color: Colors.red
       //  ),
       //    BoxShadow(
       //     offset: Offset(2,2),
       //     spreadRadius: 1,
       //     blurRadius: 4,
       //     color: Colors.redAccent
       //  ),
       // ]
    ),
      child: child,
    );
  }
}
