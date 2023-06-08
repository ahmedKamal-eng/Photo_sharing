import 'package:flutter/material.dart';
import 'package:photo_sharing_app/user_specific_posts/user_posts_screen.dart';

import 'users.dart';

class UserDesignWidget extends StatefulWidget {
  Users? model;
  BuildContext? context;

  UserDesignWidget({
    this.model,
    this.context,
  });

  @override
  State<UserDesignWidget> createState() => _UserDesignWidgetState();
}

class _UserDesignWidgetState extends State<UserDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(

      child: Padding(
        padding: EdgeInsets.all(16),
        child: Container(
          height: 240,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>UserPostsScreen(model: widget.model!)));
                },
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(widget.model!.userImage!),
                ),
              ),

              const SizedBox(height: 10,),
              Text(widget.model!.name!,
                style: const TextStyle(
                  fontSize: 26,
                  fontFamily: 'Bebas'
                ),
              ),

              const SizedBox(height: 10,),
              Text(widget.model!.email!,
                style: const TextStyle(
                  fontSize: 18,

                ),
              ),
            ],
          ),

        ),
      ),
    );
  }
}














