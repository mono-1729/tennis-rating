import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_web/cloud_firestore_web.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'mypage.dart';

class EditProfilePage extends StatefulWidget {
  final String name; //上位Widgetから受け取りたいデータ
  EditProfilePage({Key? key, required this.name}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState(this.name);
}

class _EditProfilePageState extends State<EditProfilePage> {
  // 入力した投稿メッセージ
  String ErrorText = '';
  _EditProfilePageState(this.name);
  String name;
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
                initialValue: widget.name,
                decoration: InputDecoration(labelText: '名前'),
                onChanged: (String value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              SizedBox(height: 8),
              Text(ErrorText),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: ElevatedButton(
                      child: Text('戻る'),
                      onPressed: () async {
                        await Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                            return MyWidget(selectedIndex: 3);
                          }),
                        );
                      },
                    ),
                  ),
                  Container(
                    child: ElevatedButton(
                      child: Text('保存'),
                      onPressed: () async {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .update({'name': name});
                        await Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                            return MyWidget(selectedIndex: 3);
                          }),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
