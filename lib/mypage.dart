import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_web/cloud_firestore_web.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'main.dart';
import 'login.dart';
import 'editprofile.dart';

class MyPage extends StatelessWidget {
  MyPage();
  String name = 'name';
  int rating = 0;
  @override
  Widget build(BuildContext context) {
    // ユーザー情報を受け取る
    final UserState userState = Provider.of<UserState>(context);
    final User user = userState.user!;
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('id', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<DocumentSnapshot> documents = snapshot.data!.docs;
            return MyPageState(
              name: documents[0]['name'],
              id: user.uid,
              rating: documents[0]['rating'],
              imgUrl: documents[0]['imgURL'],
            );
          }
          return Center(
            child: SizedBox(height: 8),
          );
        });
  }
}

class MyPageState extends StatefulWidget {
  String name;
  String id;
  String imgUrl;
  int rating;
  MyPageState(
      {Key? key,
      required this.name,
      required this.id,
      required this.rating,
      required this.imgUrl})
      : super(key: key);

  @override
  _MyPageState createState() =>
      _MyPageState(this.name, this.id, this.rating, this.imgUrl);
}

class _MyPageState extends State<MyPageState> {
  _MyPageState(this.name, this.id, this.rating, this.imgUrl);
  String name;
  String id;
  String imgUrl;
  int rating;
  Image? _img;

  Future<void> IndicateImage() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference imageRef = storage.ref(imgUrl);
    String imageUrl = await imageRef.getDownloadURL();
    setState(() {
      _img = Image.network(imageUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    IndicateImage();
    return Scaffold(
      body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        if (_img != null) _img!,
        SizedBox(height: 8),
        Text(name),
        SizedBox(height: 8),
        SelectableText('ID：${id}'),
        SizedBox(height: 8),
        Text('レート：${rating}'),
        SizedBox(height: 8),
        if (_img != null)
          Container(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                width: 125,
                child: ElevatedButton(
                  child: Text('編集'),
                  onPressed: () async {
                    await Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) {
                        return EditProfilePage(name: name, img: _img!);
                      }),
                    );
                  },
                ),
              ),
              SizedBox(width: 8),
              SizedBox(
                  width: 125,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    child: Text('ログアウト'),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          return LoginPage();
                        }),
                      );
                    },
                  )),
            ]),
          ),
      ])),
    );
  }
}
