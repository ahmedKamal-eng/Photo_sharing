
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:photo_sharing_app/home_screen/home_screen.dart';
import 'package:photo_sharing_app/search_post/users.dart';
import 'package:photo_sharing_app/user_specific_posts/image_screen.dart';
import 'package:photo_sharing_app/user_specific_posts/wallpaper_model.dart';
import 'package:photo_sharing_app/utils/my_colors.dart';

class UserPostsScreen extends StatefulWidget {

  final Users model;
  UserPostsScreen({required this.model});

  @override
  State<UserPostsScreen> createState() => _UserPostsScreenState();
}

class _UserPostsScreenState extends State<UserPostsScreen> {
  
  List<Wallpaper> wallpapers=[];
  
  void getImagesFromFireStore() async{
    
    FirebaseFirestore.instance.collection('wallpaper').where('id',isEqualTo: widget.model.id).get().then((value) {
      for(int i=0;i<value.docs.length;i++)
        {

          wallpapers.add(Wallpaper.fromJson(value.docs[i].data() as Map<String,dynamic>,value.docs[i].id));
        }

    }).whenComplete(() {
      setState(() {
        wallpapers;
      });
    });

  }

  @override
  void initState() {

    getImagesFromFireStore();

    super.initState();
  }
  
  
  @override
  Widget build(BuildContext context) {
     double screenHeight=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: MyColors.aqua,
        title: Text(widget.model.name!+"'s images",style: TextStyle(color: MyColors.imperial),),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.deepAqua.withOpacity(.7),
        child: Icon(Icons.home,color: MyColors.imperial,),
        onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
        },
      ),
      body: wallpapers.isEmpty ?Center(child: Text('There is no images ....'),) :
          ListView.builder(
            physics:const BouncingScrollPhysics(),
            itemBuilder: (context,index){

            return Card(

              color: MyColors.aqua,
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (contex)=>ImageScreen(model: wallpapers[index])));
                },
                child: Hero(
                  tag: wallpapers[index].imageUrl!,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    height: screenHeight * .3,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(wallpapers[index].imageUrl.toString()),
                      ),
                    ),
                  ),
                ),
              ),
            );

          },itemCount: wallpapers.length,)

    );
  }
}
