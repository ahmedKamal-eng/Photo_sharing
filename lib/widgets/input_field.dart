import 'package:flutter/material.dart';
import 'package:photo_sharing_app/widgets/text_field_container.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextEditingController textEditingController;

  InputField({
    required this.hintText,
    required this.icon,
    required this.obscureText,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(child: TextField(
       cursorColor: Colors.white,
       obscureText: obscureText,
       controller: textEditingController,
       decoration: InputDecoration(
         
         hintStyle: TextStyle(fontSize: 22),

         hintText: hintText,
         helperStyle: const TextStyle(
           color: Colors.white,
           fontSize: 26
         ),
         prefixIcon: Icon(icon,color: Color.fromRGBO(44, 51, 61, 1),size: 22,),
         border: InputBorder.none
       ),
     ),
    );
  }
}
