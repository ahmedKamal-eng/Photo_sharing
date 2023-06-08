

import 'package:cloud_firestore/cloud_firestore.dart';

class Wallpaper {
  Timestamp? createAt;
  int? downloads;
  String? imageUrl;
  String? imageId;

  Wallpaper({this.createAt,this.downloads,this.imageUrl});
  Wallpaper.fromJson(Map<String,dynamic> data,String id)
  {
    createAt= data['createdAt'];
    downloads=data['downloads'];
    imageUrl=data['image'];
    imageId=id;
  }

}