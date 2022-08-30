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
                          return MyWidget();
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
                          return MyWidget();
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
              child: Text('Yeah'),
            ),
          ),
        );
      default:
        return PostList();
    }
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
    return _Result(
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

class Rankings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 48),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _RankingsHeader(),
          Expanded(
            child: ListView(
              children: [
                _RankSample(),
                _RankSample(),
                _RankSample(),
                _RankSample(),
                _RankSample(),
                _RankSample(),
                _RankSample(),
                _RankSample(),
                _RankSample(),
                _RankSample(),
                _RankSample(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RankingsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text("らんきんぐ"));
  }
}

class _Rank extends StatelessWidget {
  final String name;
  final int ranking;
  final int rating;

  const _Rank({
    Key? key,
    required this.name,
    required this.ranking,
    required this.rating,
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
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      ranking.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(name),
              SizedBox(width: 8),
              Text(
                rating.toString(),
                strutStyle: StrutStyle(height: 1.5, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RankSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Rank(
      name: '河合 優佑',
      ranking: 10,
      rating: 1480,
    );
  }
}
