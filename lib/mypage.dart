import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_web/cloud_firestore_web.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
            return _MyPage(
                name: documents[0]['name'],
                id: user.uid,
                rating: documents[0]['rating']);
          }
          return Center(
            child: SizedBox(height: 8),
          );
        });
  }
}

class _MyPage extends StatelessWidget {
  final String name;
  final String id;
  final int rating;
  const _MyPage({
    Key? key,
    required this.name,
    required this.id,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        ClipOval(
          child: Container(
            color: Colors.greenAccent,
            width: 48,
            height: 48,
            child: Center(
              child: Text(
                name.substring(0, 1),
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(name),
        SizedBox(height: 8),
        SelectableText('ID：${id}'),
        SizedBox(height: 8),
        Text('レート：${rating}'),
        SizedBox(height: 8),
        Container(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              width: 125,
              child: ElevatedButton(
                child: Text('編集'),
                onPressed: () async {
                  await Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) {
                      return EditProfilePage(name: name);
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
