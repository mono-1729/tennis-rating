//import 'dart:ffi';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'config/config.dart';

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

// 更新可能なデータ
class UserState extends ChangeNotifier {
  User? user;

  void setUser(User newUser) {
    user = newUser;
    notifyListeners();
  }
}

void main() {
  // 最初に表示するWidget
  init();
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
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

// ログイン画面用Widget
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // メッセージ表示用
  String infoText = '';
  // 入力したメールアドレス・パスワード
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    // ユーザー情報を受け取る
    final UserState userState = Provider.of<UserState>(context);

    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // メールアドレス入力
              TextFormField(
                decoration: InputDecoration(labelText: 'メールアドレス'),
                onChanged: (String value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              // パスワード入力
              TextFormField(
                decoration: InputDecoration(labelText: 'パスワード'),
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              Container(
                padding: EdgeInsets.all(8),
                // メッセージ表示
                child: Text(infoText),
              ),
              Container(
                width: double.infinity,
                // ユーザー登録ボタン
                child: ElevatedButton(
                  child: Text('ユーザー登録'),
                  onPressed: () async {
                    try {
                      // メール/パスワードでユーザー登録
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final result = await auth.createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      // ユーザー情報を更新
                      userState.setUser(result.user!);
                      // ユーザー登録に成功した場合
                      // チャット画面に遷移＋ログイン画面を破棄
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          return AdminMobilePage();
                        }),
                      );
                    } catch (e) {
                      // ユーザー登録に失敗した場合
                      setState(() {
                        infoText = "登録に失敗しました：${e.toString()}";
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                // ログイン登録ボタン
                child: OutlinedButton(
                  child: Text('ログイン'),
                  onPressed: () async {
                    try {
                      // メール/パスワードでログイン
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final result = await auth.signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      // ユーザー情報を更新
                      userState.setUser(result.user!);
                      // ログインに成功した場合
                      // チャット画面に遷移＋ログイン画面を破棄
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          return AdminMobilePage();
                        }),
                      );
                    } catch (e) {
                      // ログインに失敗した場合
                      setState(() {
                        infoText = "ログインに失敗しました：${e.toString()}";
                      });
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

class AdminMobilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideNavigation(),
          VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: PostList(),
          ),
        ],
      ),
    );
  }
}

class SideNavigation extends StatefulWidget {
  @override
  _SideNavigationState createState() => _SideNavigationState();
}

class _SideNavigationState extends State<SideNavigation> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
      destinations: [
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
    );
  }
}

class _PostsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: ListTile(
            leading: ClipOval(
              child: Container(
                color: Colors.grey[300],
                width: 48,
                height: 48,
                child: Icon(
                  Icons.storage,
                  color: Colors.grey[800],
                ),
              ),
            ),
            title: Text('Posts'),
            subtitle: Text('20 Posts'),
          ),
        ),
        Expanded(
          flex: 1,
          child: ListTile(
            leading: ClipOval(
              child: Container(
                color: Colors.grey[300],
                width: 48,
                height: 48,
                child: Icon(
                  Icons.style,
                  color: Colors.grey[800],
                ),
              ),
            ),
            title: Text('All Types'),
            subtitle: Text(''),
          ),
        ),
      ],
    );
  }
}

class _Post extends StatelessWidget {
  final String name;
  final String message;
  final String textReason;
  final Color colorPrimary;
  final Color colorPositive;
  final String textPositive;
  final Color colorNegative;
  final String textNegative;

  const _Post({
    Key? key,
    required this.name,
    required this.message,
    required this.textReason,
    required this.colorPrimary,
    required this.colorPositive,
    required this.textPositive,
    required this.colorNegative,
    required this.textNegative,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        elevation: 8,
        shadowColor: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            ListTile(
              leading: ClipOval(
                child: Container(
                  color: colorPrimary,
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
              title: Text(name),
              subtitle: Text('2 min ago'),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 72),
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      border: Border.all(color: colorPrimary, width: 4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  SizedBox(width: 8),
                  Flexible(child: Text(message)),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: colorPrimary, width: 2),
                      ),
                    ),
                    child: Text(
                      textReason,
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                  SizedBox(width: 24),
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        primary: colorNegative,
                      ),
                      onPressed: () {},
                      child: Text(textNegative),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        primary: colorPositive,
                        backgroundColor: colorPositive.withOpacity(0.2),
                      ),
                      onPressed: () {},
                      child: Text(textPositive),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostGreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Post(
      name: 'Pean',
      message: 'Weak reason. No action required.',
      textReason: 'Report Details',
      colorPrimary: Colors.greenAccent,
      colorPositive: Colors.greenAccent,
      textPositive: 'Keep',
      colorNegative: Colors.blueAccent,
      textNegative: 'Archive',
    );
  }
}

class _PostRed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Post(
      name: 'Namaga Tema',
      message: 'Not recomended for publication.',
      textReason: 'Pending Reason',
      colorPrimary: Colors.deepOrangeAccent,
      colorPositive: Colors.blueAccent,
      textPositive: 'Publish',
      colorNegative: Colors.deepOrangeAccent,
      textNegative: 'Decline',
    );
  }
}

class _Result extends StatelessWidget {
  final String name1;
  final String name2;
  final String date;
  final int point1;
  final int point2;
  final int rate1;
  final int rate2;
  final int updated_rate1;
  final int updated_rate2;

  const _Result({
    Key? key,
    required this.name1,
    required this.name2,
    required this.date,
    required this.point1,
    required this.point2,
    required this.rate1,
    required this.rate2,
    required this.updated_rate1,
    required this.updated_rate2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        elevation: 8,
        shadowColor: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            ListTile(
              leading: ClipOval(
                child: Container(
                  color: Colors.greenAccent,
                  width: 48,
                  height: 48,
                  child: Center(
                    child: Text(
                      name1.substring(0, 1),
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),
              ),
              title: Text(name1),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 72),
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.greenAccent, width: 4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  SizedBox(width: 8),
                  Flexible(child: Text(date)),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.greenAccent, width: 2),
                      ),
                    ),
                    child: Text(
                      date,
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                  SizedBox(width: 24),
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.greenAccent,
                      ),
                      onPressed: () {},
                      child: Text(date),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.greenAccent,
                        backgroundColor: Colors.greenAccent.withOpacity(0.2),
                      ),
                      onPressed: () {},
                      child: Text(date),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Result2 extends StatelessWidget {
  final String name1;
  final String name2;
  final String date;
  final int point1;
  final int point2;
  final int rate1;
  final int rate2;
  final int updated_rate1;
  final int updated_rate2;

  const _Result2({
    Key? key,
    required this.name1,
    required this.name2,
    required this.date,
    required this.point1,
    required this.point2,
    required this.rate1,
    required this.rate2,
    required this.updated_rate1,
    required this.updated_rate2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        elevation: 8,
        shadowColor: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipOval(
                                child: Container(
                                  color: Colors.greenAccent,
                                  width: 48,
                                  height: 48,
                                  child: Center(
                                    child: Text(
                                      name1.substring(0, 1),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 24),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(name1),
                            ],
                          ),
                        ),
                        Text('Rating:${rate1}→${updated_rate1}'),
                      ],
                    ),
                  ],
                )),
                Column(
                  children: [
                    Text('${point1}-${point2}'),
                    Text(date),
                  ],
                ),
                Expanded(
                    child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipOval(
                                child: Container(
                                  color: Colors.greenAccent,
                                  width: 48,
                                  height: 48,
                                  child: Center(
                                    child: Text(
                                      name2.substring(0, 1),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 24),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(name2),
                            ],
                          ),
                        ),
                        Text('Rating:${rate2}→${updated_rate2}'),
                      ],
                    ),
                  ],
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Result2(
      name1: '山田 太郎',
      name2: '河合 優佑',
      date: '8月27日',
      point1: 3,
      point2: 2,
      rate1: 1500,
      rate2: 1500,
      updated_rate1: 1520,
      updated_rate2: 1480,
    );
  }
}

class PostList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 48),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _PostsHeader(),
          Expanded(
            child: ListView(
              children: [
                _ResultSample(),
                _ResultSample(),
                _ResultSample(),
                _ResultSample(),
                _ResultSample(),
                _ResultSample(),
                _ResultSample(),
                _ResultSample(),
                _ResultSample(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
