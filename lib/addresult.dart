import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  int point1 = -1;
  int point2 = -1;
  String ResultText = '';
  String _labelText = '日付を選択';
  String ErrorText = "";

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
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(labelText: '自分の得点'),
                      onChanged: (String value) {
                        setState(() {
                          if (value == "") point1 = -1;
                          point1 = int.parse(value);
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(labelText: '相手の得点'),
                      onChanged: (String value) {
                        setState(() {
                          if (value == "") point2 = -1;
                          point2 = int.parse(value);
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(ErrorText),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('追加'),
                  onPressed: () async {
                    if (opponentid == "") {
                      setState(() {
                        ErrorText = "相手のIDを入力してください";
                      });
                    } else if (_labelText == '日付を選択') {
                      setState(() {
                        ErrorText = "日付を入力してください";
                      });
                    } else if (point1 < 0 || point2 < 0) {
                      setState(() {
                        ErrorText = "得点を入力してください";
                      });
                    } else {
                      final playerdoc = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .get();
                      final opponentdoc = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(opponentid)
                          .get();
                      if (opponentdoc.exists) {
                        final date =
                            DateTime.now().toLocal().toIso8601String(); // 現在の日時
                        final email = user.email; // AddPostPage のデータを参照
                        // 投稿メッセージ用ドキュメント作成
                        await FirebaseFirestore.instance
                            .collection('results') // コレクションID指定
                            .doc() // ドキュメントID自動生成
                            .set({
                          'playerid': user.uid,
                          'playername': playerdoc["name"],
                          'opponentid': opponentid,
                          'opponentname': opponentdoc["name"],
                          'point1': point1,
                          'point2': point2,
                          'rate1': playerdoc['rating'],
                          'rate2': opponentdoc['rating'],
                          'updated_rate1': 1500,
                          'updated_rate2': 1500,
                          'date': _labelText,
                        });
                        setState(() {
                          ErrorText = "";
                        });
                      } else {
                        setState(() {
                          ErrorText = "相手のIDが間違っています";
                        });
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
