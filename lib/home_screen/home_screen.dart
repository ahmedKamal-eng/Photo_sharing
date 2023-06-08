import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:photo_sharing_app/log_in/login_screen.dart';
import 'package:photo_sharing_app/owner_details/owner_details.dart';
import 'package:photo_sharing_app/profile_screen/profile_screen.dart';
import 'package:photo_sharing_app/search_post/search_post.dart';
import 'package:photo_sharing_app/utils/my_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String changeTitle = "Grid View";
  bool checkView = false;


  File? imageFile;
  String? imageUrl;
  String? myImage;
  String? myName;
  bool isImageSelected=false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _showSignOutDialog(){

    showDialog(context: context, builder: (context){
      return AlertDialog(
         title: Text('SignOut ...'),
          backgroundColor: MyColors.deepAqua,
        content: Text('do you want to sign out?'),
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: MyColors.imperial),
              onPressed: (){

            FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => LoginScreen()));
          }, child: Text('sign out')),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: MyColors.imperial),
              onPressed: (){
            Navigator.pop(context);
          }, child: Text('cancel')),
        ],
      );
    });

  }

  void _showImageDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: MyColors.aqua,
            title: Text('Please Chose an option'),
            content: Container(
              height: 80,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      _getFromCamera();
                      setState(() {
                        isImageSelected=true;
                      });
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.camera,
                            color: MyColors.primary,
                          ),
                        ),
                        Text(
                          'Camera',
                          style: TextStyle(color: MyColors.primary),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _getFromGallery();
                      setState(() {
                        isImageSelected=true;
                      });
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.image,
                            color: MyColors.primary,
                          ),
                        ),
                        Text(
                          'Gallery',
                          style: TextStyle(color: MyColors.primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _getFromCamera() async {
    XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(pickedImage!.path);
    Navigator.pop(context);
  }

  void _getFromGallery() async {
    XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(pickedImage!.path);
    Navigator.pop(context);
  }

  void _cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper()
        .cropImage(sourcePath: filePath, maxHeight: 1080, maxWidth: 1080);

    if (croppedImage != null) {
      imageFile = File(croppedImage.path);
      setState(() {});
    }
  }

  void _uploadImage() async {
    if (imageFile == null) {
      Fluttertoast.showToast(
          msg: 'Please select an image',
          textColor: Colors.black,
          backgroundColor: MyColors.aqua);
      return;
    }

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('userImage')
          .child(DateTime.now().toString() + 'jpg');
      await ref.putFile(imageFile!);
      imageUrl = await ref.getDownloadURL();
      FirebaseFirestore.instance
          .collection('wallpaper')
          .doc(DateTime.now().toString())
          .set({
        'id': _auth.currentUser!.uid,
        'userImage': myImage,
        'name': myName,
        'email': _auth.currentUser!.email,
        'image': imageUrl,
        'downloads': 0,
        'createdAt': DateTime.now()
      });

      Navigator.canPop(context) ? Navigator.pop(context) : null;
      imageFile = null;
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: Colors.redAccent,
          textColor: Colors.black);
    }
  }

  void readUserInfo() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then<dynamic>((DocumentSnapshot snapshot) {
      myImage = snapshot.get('userImage');
      myName = snapshot.get('name');
    });
  }

  @override
  void initState() {
    readUserInfo();
    super.initState();
  }

  Widget listViewWidget(String docId, String img, String userImg, String name,
      DateTime date, String userId, int downloads) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Card(
        elevation: 16,
        shadowColor: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            color: MyColors.deepAqua,
          ),
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(seconds: 1),
                      pageBuilder: (_, __, ___) => OwnerDetails(
                        img: img,
                        userImage: userImg,
                        name: name,
                        date: date,
                        docId: docId,
                        userId: userId,
                        downloads: downloads,
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: docId,
                  child: Image.network(
                    img,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(userImg),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          DateFormat("dd MMMM, yyyy - hh:mm a")
                              .format(date)
                              .toString(),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget gridViewWidget(String docId, String img, String userImg, String name,
      DateTime date, String userId, int downloads) {
    return GridView.count(
      primary: false,
      padding: EdgeInsets.all(6),
      crossAxisSpacing: 1,
      crossAxisCount: 1,
      children: [
        Container(
          color: MyColors.aqua,
          padding: EdgeInsets.all(10),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: Duration(seconds: 1),
                  pageBuilder: (_, __, ___) => OwnerDetails(
                    img: img,
                    userImage: userImg,
                    name: name,
                    date: date,
                    docId: docId,
                    userId: userId,
                    downloads: downloads,
                  ),
                ),
              );
            },
            child: Center(
              child: Hero(
                tag: docId,
                child: Image.network(
                  img,
                  fit: BoxFit.cover,
                  width: 100,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Wrap(
        direction: Axis.horizontal,
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: FloatingActionButton(
              heroTag: "1",
              backgroundColor:isImageSelected?Colors.black54 : MyColors.deepAqua.withOpacity(.7),
              onPressed:isImageSelected?null: () {

                _showImageDialog();

              },
              child: Icon(Icons.camera_enhance),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: FloatingActionButton(
              heroTag: "2",
              backgroundColor:isImageSelected? MyColors.deepAqua.withOpacity(.7):Colors.black54,
              onPressed:isImageSelected?
                  () {
                _uploadImage();
                setState(() {
                  isImageSelected=false;
                });
              }:null,
              child: const Icon(Icons.cloud_upload),
            ),
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: MyColors.aqua,
        title: InkWell(
          onTap: () {
            if (checkView) {
              changeTitle = "Grid View";
              checkView = false;
              setState(() {});
            } else {
              changeTitle = "list View";
              checkView = true;
              setState(() {});
            }
          },
          // onDoubleTap: () {
          //   changeTitle = "Grid View";
          //   checkView = false;
          //   setState(() {});
          // },
          child: Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // checkView ?Icon(Icons.view_column,):Icon(Icons.grid_4x4,),
                Switch(
                  value: checkView,
                  onChanged: (v) {
                    checkView = v;
                    changeTitle = checkView ? "list View" : "Grid View";
                    setState(() {});
                  },
                  activeColor: MyColors.primary,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  changeTitle,
                  style: const TextStyle(color:MyColors.primary),
                ),
              ],
            ),
          ),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {

            _showSignOutDialog();

            // FirebaseAuth.instance.signOut();
            // Navigator.pushReplacement(
            //     context, MaterialPageRoute(builder: (_) => LoginScreen()));
          },
          child: Icon(
            Icons.login_outlined,
            color: MyColors.primary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  SearchPost(),
                ),
              );
            },
            icon:const Icon(Icons.person_search,color: MyColors.primary,size: 30),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  ProfileScreen(),
                ),
              );
            },
            icon:const Icon(Icons.person,color: MyColors.primary,size: 30),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("wallpaper")
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: MyColors.aqua,
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data!.docs.isNotEmpty) {
              if (checkView == true) {
                return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return listViewWidget(
                          snapshot.data!.docs[index].id,
                          snapshot.data!.docs[index]['image'],
                          snapshot.data!.docs[index]['userImage'],
                          snapshot.data!.docs[index]['name'],
                          snapshot.data!.docs[index]['createdAt'].toDate(),
                          snapshot.data!.docs[index]['id'],
                          snapshot.data!.docs[index]['downloads']);
                    });
              } else {
                return GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) {
                    return gridViewWidget(
                        snapshot.data!.docs[index].id,
                        snapshot.data!.docs[index]['image'],
                        snapshot.data!.docs[index]['userImage'],
                        snapshot.data!.docs[index]['name'],
                        snapshot.data!.docs[index]['createdAt'].toDate(),
                        snapshot.data!.docs[index]['id'],
                        snapshot.data!.docs[index]['downloads']);
                  },
                );
              }
            } else {
              return const Center(
                child: Text(
                  'there is no tasks',
                  style: TextStyle(fontSize: 20),
                ),
              );
            }
          }
          return const Center(
            child: Text(
              'something went wrong',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 0),
            ),
          );
        },
      ),
    );
  }
}
