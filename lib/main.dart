//import 'dart:ffi';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'config/config.dart';
import 'login.dart';
import 'result.dart';
import 'ranking.dart';

final configurations = Configurations();

Future<void> init() async {
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: configurations.apiKey,
    appId: configurations.appId,
    messagingSenderId: configurations.messagingSenderId,
    projectId: configurations.projectId,
    //authDomain: configurations.authDomain,
    //storageBucket: configurations.storageBucket,
  ));
}

void main() {
  // 最初に表示するWidget
  init();
  runApp(RatingApp());
}

class RatingApp extends StatelessWidget {
  // ユーザーの情報を管理するデータ
  final UserState userState = UserState();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserState>(
      create: (context) => UserState(),
      child: MaterialApp(
        // アプリ名
        title: 'ChatApp',
        theme: ThemeData(
          // テーマカラー
          primarySwatch: Colors.blue,
        ),
        // ログイン画面を表示
        home: LoginPage(),
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.thumbs_up_down),
                label: Text('ThumbsUpDown'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people),
                label: Text('People'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.face),
                label: Text('Face'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.bookmark),
                label: Text('Bookmark'),
              ),
            ],
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
          VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: MainContents(index: selectedIndex),
          ),
        ],
      ),
    );
  }
}

class MainContents extends StatelessWidget {
  const MainContents({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    switch (index) {
      case 1:
        return Rankings();
      case 2:
        return Container(
          child: ColoredBox(
            color: Colors.blue[200]!,
            child: const Center(
              child: Text('Bookmark'),
            ),
          ),
        );
      case 3:
        return Container(
          child: ColoredBox(
            color: Colors.green[200]!,
            child: const Center(
              child: Text('Hello'),
            ),
          ),
        );
      default:
        return PostList();
    }
  }
}
