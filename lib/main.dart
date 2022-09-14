//import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'config/config.dart';
import 'login.dart';
import 'result.dart';
import 'ranking.dart';
import 'addresult.dart';
import 'mypage.dart';

final configurations = Configurations();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: configurations.apiKey,
    appId: configurations.appId,
    messagingSenderId: configurations.messagingSenderId,
    projectId: configurations.projectId,
    //authDomain: configurations.authDomain,
    //storageBucket: configurations.storageBucket,
  ));
  final firebaseUser = await FirebaseAuth.instance.userChanges().first;
  runApp(RatingApp());
}

class UserState extends ChangeNotifier {
  User? user;

  void setUser(User newUser) {
    user = newUser;
    notifyListeners();
  }
}

class RatingApp extends StatelessWidget {
  // ユーザーの情報を管理するデータ
  final UserState userState = UserState();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserState>(
      create: (context) => UserState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // アプリ名
        title: 'RatingApp',
        theme: ThemeData(
          // テーマカラー
          primarySwatch: Colors.blue,
        ),
        // ログイン画面を表示
        home: LoginCheck(),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  final int selectedIndex;
  const MyWidget({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState(this.selectedIndex);
}

class _MyWidgetState extends State<MyWidget> {
  final UserState user = UserState();
  _MyWidgetState(this.selectedIndex);
  int selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Divider(thickness: 1, height: 1),
          Expanded(
            child: MainContents(index: selectedIndex),
          ),
          BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.list_outlined),
                label: '試合結果一覧',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.format_list_numbered_outlined),
                label: 'ランキング',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.playlist_add_outlined),
                label: '試合結果を追加',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: 'マイページ',
              ),
            ],
            currentIndex: selectedIndex,
            selectedItemColor: Colors.greenAccent,
            unselectedItemColor: Colors.grey[800],
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
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
        return AddResultPage();
      case 3:
        return MyPage();
      default:
        return PostList();
    }
  }
}
