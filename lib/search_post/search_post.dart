import 'package:flutter/material.dart';
import 'package:photo_sharing_app/search_post/user_desgin_widget.dart';
import 'package:photo_sharing_app/search_post/users.dart';
import 'package:photo_sharing_app/utils/my_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPost extends StatefulWidget {
  const SearchPost({Key? key}) : super(key: key);

  @override
  State<SearchPost> createState() => _SearchPostState();
}

class _SearchPostState extends State<SearchPost> {
  Future<QuerySnapshot>? postDocumentsList;
  String? userNameText = "";

  List<Users> users = [];
  bool isLoad = false;

  initSearchingPost(String textEntered) async {
    users = [];
    isLoad = true;
    FirebaseFirestore.instance.collection("users").get().then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        if (value.docs[i]['name']
            .toString()
            .toLowerCase()
            .startsWith(textEntered.toLowerCase()) && textEntered.isNotEmpty) {
          users.add(
              Users.fromJson(value.docs[i].data() as Map<String, dynamic>));
        }
      }
    }).whenComplete(() {
      setState(() {
        isLoad = false;
        // postDocumentsList;
        users;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: MyColors.aqua,
        title: TextField(
          onChanged: (textEntered) {
            setState(() {
              userNameText = textEntered;
            });
            initSearchingPost(textEntered);
          },
          decoration: InputDecoration(
            hintText: "Text Post Here ...",
            hintStyle: TextStyle(
                color: MyColors.imperial, fontWeight: FontWeight.bold),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.search,
                color: MyColors.imperial,
                size: 30,
              ),
              onPressed: () {
                initSearchingPost(userNameText!);
              },
            ),
            prefixIcon: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: MyColors.imperial,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: isLoad
          ? Center(
              child: CircularProgressIndicator(
                color: MyColors.deepAqua,
              ),
            )
          : users.length == 0
              ? Center(
                  child: Text('No Record Exist...'),
                )
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return UserDesignWidget(
                      model: users[index],
                      context: context,
                    );
                  },
                  itemCount: users.length,
                ),

      // FutureBuilder<QuerySnapshot>(
      //   future: postDocumentsList,
      //   builder: (context, AsyncSnapshot snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(
      //         child: CircularProgressIndicator(
      //           color: MyColors.deepAqua,
      //         ),
      //       );
      //     } else {
      //       return snapshot.hasData
      //           ? ListView.builder(
      //               physics: const BouncingScrollPhysics(),
      //               itemBuilder: (context, index) {
      //                 return UserDesignWidget(
      //                   model: Users.fromJson(snapshot.data!.docs[index].data()
      //                       as Map<String, dynamic>),
      //                   context: context,
      //                 );
      //               },
      //               itemCount: snapshot.data!.docs.length,
      //             )
      //           : Center(
      //               child: Text('No Record Exist...'),
      //             );
      //     }
      //   },
      // ),
    );
  }
}
