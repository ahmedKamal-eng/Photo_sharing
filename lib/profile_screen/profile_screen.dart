import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_sharing_app/home_screen/home_screen.dart';
import 'package:photo_sharing_app/log_in/login_screen.dart';
import 'package:photo_sharing_app/utils/my_colors.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? name = "";
  String? email = "";
  String? image = "";
  String? phoneNo = "";
  File? imageXFile;
  String? userNameInput = "";
  String? userImageUrl = "";

  Future _getDataFromDatabase() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) async {
      setState(() {
        name = snapshot.data()!['name'];
        email = snapshot.data()!['email'];
        image = snapshot.data()!['userImage'];
        phoneNo = snapshot.data()!['phoneNumber'];
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _getDataFromDatabase();
  }

  void _showImageDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Please Chose an option'),
            content: Container(
              height: 80,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      _getFromCamera();
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
                          style: TextStyle(color: Colors.deepOrange),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _getFromGallery();
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
                          style: TextStyle(color: Colors.deepOrange),
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
      setState(() {
        imageXFile = File(croppedImage.path);
        _updateImageInFirestore();
      });
    }
  }

  void _updateUserName() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'name': userNameInput,
    });
  }

  _displayTextInputDialog(BuildContext context, double rPadding) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: MyColors.aqua,
            title: const Text("Update Your name here"),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  userNameInput = value;
                });
              },
              decoration: const InputDecoration(hintText: "Type Here"),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: rPadding),
                child: ElevatedButton(
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent),
                ),
              ),
              ElevatedButton(
                child: const Text(
                  "Save",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _updateUserName();
                    updateProfileNameOnUserExistingPosts();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HomeScreen(),
                      ),
                    );
                  });
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.imperial),
              ),
            ],
          );
        });
  }

  void _updateImageInFirestore() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    fStorage.Reference referenc = fStorage.FirebaseStorage.instance
        .ref()
        .child("userImages")
        .child(fileName);

    fStorage.UploadTask uploadTask = referenc.putFile(File(imageXFile!.path));

    fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    await taskSnapshot.ref.getDownloadURL().then((url) async {
      userImageUrl = url;
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'userImage': userImageUrl}).whenComplete(() {
      updateProfileImageOnUserExistingPosts();
    });
  }

  updateProfileImageOnUserExistingPosts() async {
    await FirebaseFirestore.instance
        .collection('wallpaper')
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) {

          for (int index=0;index<snapshot.docs.length;index++)
            {
              FirebaseFirestore.instance.collection('wallpaper').doc(snapshot.docs[index].id).update(
                  {
                    "userImage":userImageUrl
                  });
            }

    });
  }

  updateProfileNameOnUserExistingPosts() async {
    await FirebaseFirestore.instance
        .collection('wallpaper')
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) {

          for (int index=0;index<snapshot.docs.length;index++)
            {
              FirebaseFirestore.instance.collection('wallpaper').doc(snapshot.docs[index].id).update(
                  {
                    "name":userNameInput
                  });
            }

    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: MyColors.imperial,
        centerTitle: true,
        title: const Text(
          'Profile Screen',
          style: TextStyle(
            color: Colors.white,
            fontSize: 35,
            shadows: [
              Shadow(
                blurRadius: 15.0,
                color: Color.fromRGBO(44, 51, 61, 1),
                offset: Offset(11.0, 11.0),
              ),
            ],
            letterSpacing: 2.5,
            fontWeight: FontWeight.bold,
            fontFamily: 'Signatra',
          ),
        ),
      ),
      backgroundColor: MyColors.deepGrey,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             SizedBox(height: screenHeight * 0.15,),
            GestureDetector(
              onTap: () {
                _showImageDialog();
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                minRadius: 65,
                child: CircleAvatar(
                  radius: 57,
                  backgroundImage: imageXFile == null
                      ? NetworkImage(image!)
                      : Image.file(imageXFile!).image,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Name : ' + name!,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  onPressed: () {
                    _displayTextInputDialog(context, screenWidth * .3);
                  },
                  icon: Icon(
                    Icons.edit,
                    color: MyColors.imperial,
                    size: 35,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Email : " + email!,
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Phone Number : " + phoneNo!,
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginScreen(),
                  ),
                );
              },
              child: Text(
                "Logout",
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.imperial,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
