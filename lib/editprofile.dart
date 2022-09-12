import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_web/cloud_firestore_web.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'mypage.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage();

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // 入力した投稿メッセージ

  @override
  Widget build(BuildContext context) {
    // ユーザー情報を受け取る
    final UserState userState = Provider.of<UserState>(context);
    final User user = userState.user!;

    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: '相手のID'),
                onChanged: (String value) {
                  setState(() {
                    //opponentid = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
