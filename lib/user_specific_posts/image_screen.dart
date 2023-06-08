

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:intl/intl.dart';
import 'package:photo_sharing_app/user_specific_posts/wallpaper_model.dart';
import 'package:photo_sharing_app/utils/my_colors.dart';

class ImageScreen extends StatelessWidget {
 Wallpaper model;
 ImageScreen({required this.model});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.black,
        child: Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [

              Hero(
                  tag: model.imageUrl!,
                  child: Image(image: NetworkImage(model.imageUrl!))),
              const SizedBox(height: 10,),
              Center(
                child: Text(
                  DateFormat("dd MMMM, yyyy - hh:mm a")
                      .format(model.createAt!.toDate())
                      .toString(),
                  style: TextStyle(
                    fontSize: 25,
                      color: MyColors.aqua, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(model.downloads.toString(),
                  style: TextStyle(color: MyColors.aqua,fontSize: 30),
                  ),
                  const SizedBox(width: 10,),
                  Icon(Icons.download_outlined,color: MyColors.aqua,size: 30,)
                ],
              ),


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 50),
                child: Container(height: 4,width:double.infinity,color: MyColors.aqua,),
              ),

              const SizedBox(height: 80,),
              InkWell(
                onTap: () async{
                  try{
                    var imageId=await ImageDownloader.downloadImage(model.imageUrl!);
                    if(imageId == null)
                    {
                      return;
                    }
                    Fluttertoast.showToast(msg: "image Saved to Gallery",backgroundColor: MyColors.imperial,textColor: Colors.white);
                    int total= model.downloads! +1;
                    FirebaseFirestore.instance.collection('wallpaper').doc(model.imageId).update(
                        {'downloads':total}).then((value) {
                      Navigator.pop(context);
                    });
                  }
                  on PlatformException catch(e)
                  {
                    print(e.toString());
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 90),
                  child: Container(

                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                    child: Text('Download',style: TextStyle(color: Colors.white,fontSize: 30),),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),

                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40,)


            ],
          ),
        ),
      ),
    );
  }
}
