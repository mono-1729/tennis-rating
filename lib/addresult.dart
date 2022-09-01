import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'main.dart';

class AddResultPage extends StatefulWidget {
  AddResultPage();

  @override
  _AddResultPageState createState() => _AddResultPageState();
}

class _AddResultPageState extends State<AddResultPage> {
  // 入力した投稿メッセージ
  String opponentid = '';
  String point1 = '';
  String point2 = '';
  String ResultText = '';
  String _labelText = '日付を選択';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      locale: const Locale("ja"),
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 2),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (selected != null) {
      setState(() {
        _labelText = (DateFormat.yMMMd('ja')).format(selected);
      });
    }
  }

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
              Container(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        _labelText,
                        style: TextStyle(fontSize: 18),
                      ),
                      IconButton(
                        icon: Icon(Icons.date_range),
                        onPressed: () => _selectDate(context),
                      )
                    ],
                  ),
                ),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '相手のID'),
                onChanged: (String value) {
                  setState(() {
                    opponentid = value;
                  });
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: '自分の得点'),
                      onChanged: (String value) {
                        setState(() {
                          point1 = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: '相手の得点'),
                      onChanged: (String value) {
                        setState(() {
                          point2 = value;
                        });
                      },
                    ),
                  ),
                ],
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
                      'playerid': user.uid,
                      'opponentid': opponentid,
                      'point1': point1,
                      'point2': point2,
                      'date': date,
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
