import 'package:flutter/material.dart';

class HeadText extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(height: size.height * 0.1,),
         Center(
           child: Stack(
             children: [
               Text('Photo Sharing',
                 style: TextStyle(
                     color: Colors.white,
                     fontSize: 70,
                     shadows: [
                       Shadow(
                         blurRadius: 15.0,
                         color: Color.fromRGBO(44, 51, 61, 1),
                         offset: Offset(11.0, 11.0),
                       ),
                     ],
                     letterSpacing: 2.5,
                     fontWeight: FontWeight.bold,
                     fontFamily: 'Signatra'
                 ),
               ),
             ],
           ),
        ),
        const SizedBox(height: 20,),
        const Center(
          child: Text('Login',style: TextStyle(
             fontSize: 50,
             color: Color.fromRGBO(44, 51, 61, 1),
             fontWeight: FontWeight.bold,
            fontFamily: 'Bebas'
           ),
          ),
        ),

      ],
    );
  }
}
