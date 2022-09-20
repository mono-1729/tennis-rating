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
              playstyle: documents[0]['playstyle'],
              dominanthand: documents[0]['dominanthand'],
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
  String playstyle;
  String dominanthand;
  int rating;
  MyPageState({
    Key? key,
    required this.name,
    required this.id,
    required this.rating,
    required this.imgUrl,
    required this.playstyle,
    required this.dominanthand,
  }) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState(this.name, this.id, this.rating,
      this.imgUrl, this.playstyle, this.dominanthand);
}

class _MyPageState extends State<MyPageState> {
  _MyPageState(this.name, this.id, this.rating, this.imgUrl, this.playstyle,
      this.dominanthand);
  String name;
  String id;
  String imgUrl;
  String playstyle;
  String dominanthand;
  int rating;
  Image? img;

  Future<void> IndicateImage(imgURL) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference imageRef = storage.ref(imgURL);
    String imageUrl = await imageRef.getDownloadURL();
    if (mounted) {
      setState(() {
        img = Image.network(imageUrl);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context);
    final User user = userState.user!;
    IndicateImage(imgUrl);
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            if (img == null)
              Text(
                '読み込み中…',
                style: TextStyle(fontFamily: 'KosugiMaru'),
              ),
            if (img != null)
              ClipOval(
                child: Container(
                  width: 64,
                  height: 64,
                  child: img!,
                ),
              ),
            if (img != null) SizedBox(height: 8),
            if (img != null)
              Text(
                name,
                style: TextStyle(fontSize: 20, fontFamily: 'KosugiMaru'),
              ),
            if (img != null) SizedBox(height: 8),
            if (img != null)
              Text(
                'レート：${rating}',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            if (img != null) SizedBox(height: 8),
            if (img != null)
              Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Column(children: [
                      SelectableText('ID'),
                      SizedBox(height: 8),
                      Text('利き手'),
                      SizedBox(height: 8),
                      Text('プレースタイル'),
                      SizedBox(height: 8),
                    ]),
                    Column(children: [
                      SelectableText('：'),
                      SizedBox(height: 8),
                      Text('：'),
                      SizedBox(height: 8),
                      Text('：'),
                      SizedBox(height: 8),
                    ]),
                    SizedBox(width: 8),
                    Column(children: [
                      SelectableText('${id}'),
                      SizedBox(height: 8),
                      Text('${dominanthand}'),
                      SizedBox(height: 8),
                      Text('${playstyle}'),
                      SizedBox(height: 8),
                    ]),
                  ])),
            if (img != null) SizedBox(height: 8),
            if (img != null)
              Container(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                    width: 125,
                    child: ElevatedButton(
                      child: Text('編集'),
                      onPressed: () async {
                        await Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                            return EditProfilePage(
                                name: name,
                                img: img!,
                                id: user.uid,
                                playstyle: playstyle,
                                dominanthand: dominanthand);
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
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
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
