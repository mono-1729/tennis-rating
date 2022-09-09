import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'login.dart';

class MyPage extends StatefulWidget {
  MyPage();

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  // 入力した投稿メッセージ

  @override
  Widget build(BuildContext context) {
    // ユーザー情報を受け取る
    final UserState userState = Provider.of<UserState>(context);
    final User user = userState.user!;
    return Scaffold(
      body: Center(
          child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<DocumentSnapshot> documents = snapshot.data!.docs;
            return Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  child: ElevatedButton(
                child: Text('Sign Out'),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  await Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) {
                      return LoginPage();
                    }),
                  );
                },
              )),
            ]);
          }
          return Center(child: Text('読み込み中...'));
        },
      )),
    );
  }
}
