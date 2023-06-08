import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_sharing_app/account_check/account_check.dart';
import 'package:photo_sharing_app/home_screen/home_screen.dart';
import 'package:photo_sharing_app/log_in/login_screen.dart';
import 'package:photo_sharing_app/utils/my_colors.dart';
import 'package:photo_sharing_app/widgets/button_square.dart';
import 'package:photo_sharing_app/widgets/input_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Credentials extends StatefulWidget {
  const Credentials({Key? key}) : super(key: key);

  @override
  State<Credentials> createState() => _CredentialsState();
}

class _CredentialsState extends State<Credentials> {
  final TextEditingController _fullNameController =
      TextEditingController(text: "");
  final TextEditingController _emailController =
      TextEditingController(text: "");
  final TextEditingController _passwordController =
      TextEditingController(text: "");
  final TextEditingController _phoneController =
      TextEditingController(text: "");

  File? imageFile;
  String? imageUrl;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
      imageFile = File(croppedImage.path);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(50),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              _showImageDialog();
            },
            child: CircleAvatar(
              radius: 90,
              backgroundImage: imageFile == null
                  ? const AssetImage('images/avatar.png')
                  : Image.file(imageFile!).image,
              child: CircleAvatar(
                radius: 85,
                backgroundColor:imageFile == null? Colors.black54 : Colors.transparent,
                child: imageFile == null ? Icon(Icons.add_a_photo_outlined,color: Color(0xff01a3a4),size: 40,) : null,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          InputField(
            hintText: 'Enter UserName',
            icon: Icons.person,
            obscureText: false,
            textEditingController: _fullNameController,
          ),
          const SizedBox(
            height: 10,
          ),
          InputField(
            hintText: 'Enter Email',
            icon: Icons.email_rounded,
            obscureText: false,
            textEditingController: _emailController,
          ),
          const SizedBox(
            height: 10,
          ),
          InputField(
            hintText: 'Enter Your Phone',
            icon: Icons.phone,
            obscureText: false,
            textEditingController: _phoneController,
          ),
          const SizedBox(
            height: 10,
          ),
          InputField(
            hintText: 'Enter password',
            icon: Icons.lock,
            obscureText: true,
            textEditingController: _passwordController,
          ),
          const SizedBox(
            height: 15,
          ),
          ButtonSquare(
            text: 'Create Account',
            press: () async {
              if (imageFile == null) {
                Fluttertoast.showToast(msg: 'Please select an Image');
                return;
              }
              try {
                final ref = FirebaseStorage.instance
                    .ref()
                    .child('userImages')
                    .child(DateTime.now().toString());
                await ref.putFile(imageFile!);
                imageUrl = await ref.getDownloadURL();

                await _auth.createUserWithEmailAndPassword(
                    email: _emailController.text.trim().toLowerCase(),
                    password: _passwordController.text.trim());

                final User? user=_auth.currentUser;
                final _uid=user!.uid;

                FirebaseFirestore.instance.collection('users').doc(_uid).set(
                    {
                      'id':_uid,
                      'userImage':imageUrl,
                      'name':_fullNameController.text,
                      'email':_emailController.text,
                      'phoneNumber':_phoneController.text,
                      'createdAt':Timestamp.now()
                    });
                // canPop method return false if you are in the first page
                Navigator.canPop(context)? Navigator.pop(context):null;
              }
              catch (e) {

                Fluttertoast.showToast(msg: e.toString());
              }
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>HomeScreen()));
            },
            color: MyColors.primary,
          ),
          AccountCheck(login: false, press: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoginScreen()));

          }),
        ],
      ),
    );
  }
}
