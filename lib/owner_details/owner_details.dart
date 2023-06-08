import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:intl/intl.dart';
import 'package:photo_sharing_app/home_screen/home_screen.dart';
import 'package:photo_sharing_app/utils/my_colors.dart';
import 'package:photo_sharing_app/widgets/button_square.dart';

class OwnerDetails extends StatefulWidget {
  String? img;
  String? userImage;
  String? name;
  DateTime? date;
  String? docId;
  String? userId;
  int? downloads;

  OwnerDetails(
      {this.img,
      this.userImage,
      this.name,
      this.date,
      this.docId,
      this.userId,
      this.downloads});

  @override
  State<OwnerDetails> createState() => _OwnerDetailsState();
}

class _OwnerDetailsState extends State<OwnerDetails> {
  int? total;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: MyColors.deepAqua
        ),
        child: ListView(
          physics:const BouncingScrollPhysics(),
            children: [
              Column(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Hero(
                          tag: widget.docId!,
                          child: Image.network(widget.img!,
                           width: MediaQuery.of(context).size.width,
                          ),
                        ),

                      ],
                    ),

                  ),
                  const SizedBox(height: 30,),
                  const Text('Owner Information',
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'lobster',
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 30,),

                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage( image: NetworkImage(widget.userImage!),
                        fit: BoxFit.cover
                      ),
                    ),
                  ),

                  const SizedBox(height: 10,),
                  Text(
                    DateFormat("dd MMMM, yyyy - hh:mm a").format(widget.date!).toString(),
                    style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 50,),
                  Text("updated by : "+widget.name!,style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontFamily: 'Varela',
                    fontWeight: FontWeight.bold
                  ),),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.download_outlined,
                        size: 40,
                        color: Colors.white,
                      ),
                      Text(
                        " "+widget.downloads.toString(),
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 50,),

                  Padding(padding: EdgeInsets.only(left: 8,right: 8),
                    child: ButtonSquare(
                      text: "Download",
                      color: MyColors.primary,
                      press: () async {
                        try{
                          var imageId=await ImageDownloader.downloadImage(widget.img!);
                          if(imageId == null)
                            {
                              return;
                            }
                          Fluttertoast.showToast(msg: "image Saved to Gallery");
                         total= widget.downloads! +1;
                          FirebaseFirestore.instance.collection('wallpaper').doc(widget.docId!).update(
                              {'downloads':total}).then((value) {
                                Navigator.pop(context);
                          });
                        }
                        on PlatformException catch(e)
                        {
                               print(e.toString());
                        }
                      },
                    ),
                  ),

                  FirebaseAuth.instance.currentUser!.uid ==widget.userId ?
                      Padding(padding: EdgeInsets.only(left: 8,right: 8),
                        child: ButtonSquare(
                          text: "Delete",
                          color: MyColors.primary,
                          press: (){
                            FirebaseFirestore.instance.collection("wallpaper").doc(widget.docId).delete().then((value) {
                              Navigator.pop(context);
                            });
                          },
                        ),
                      ) :Container(),

                  Padding(padding: EdgeInsets.only(left: 8,right: 8),
                      child: ButtonSquare(
                        text: "Go Back",
                        color: MyColors.primary,
                        press: () async{
                          Navigator.pop(context);
                        },
                      ),
                  ),
                ],
              ),
            ],
         ),
      ),
    );
  }
}














