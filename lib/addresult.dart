import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class AddResultPage extends StatefulWidget {
  AddResultPage();

  @override
  _AddResultPageState createState() => _AddResultPageState();
}

class _AddResultPageState extends State<AddResultPage> {
  // 入力した投稿メッセージ
  String opponentName = '';
  String ResultText = '';

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
                decoration: InputDecoration(labelText: '相手の名前'),
                onChanged: (String value) {
                  setState(() {
                    opponentName = value;
                  });
                },
              ),
              // 投稿メッセージ入力
              TextFormField(
                decoration: InputDecoration(labelText: '試合結果'),
                // 複数行のテキスト入力
                keyboardType: TextInputType.multiline,
                // 最大3行
                maxLines: 1,
                onChanged: (String value) {
                  setState(() {
                    ResultText = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('追加'),
                  onPressed: () async {
                    final date =
                        DateTime.now().toLocal().toIso8601String(); // 現在の日時
                    final email = user.email; // AddPostPage のデータを参照
                    // 投稿メッセージ用ドキュメント作成
                    await FirebaseFirestore.instance
                        .collection('results') // コレクションID指定
                        .doc() // ドキュメントID自動生成
                        .set({
                      'opponentName': opponentName,
                      'email': email,
                      'date': date
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
