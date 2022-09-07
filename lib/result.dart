import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

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

class PostList extends StatelessWidget {
  PostList();
  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context);
    final User user = userState.user!;
    return Container(
      padding: EdgeInsets.only(top: 48),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          //_PostsHeader(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('results')
                  .orderBy('date')
                  .snapshots(),
              builder: (context, snapshot) {
                // データが取得できた場合
                if (snapshot.hasData) {
                  final List<DocumentSnapshot> documents = snapshot.data!.docs;
                  // 取得した投稿メッセージ一覧を元にリスト表示
                  return ListView(
                    children: documents.map((document) {
                      return _Result(
                          name1: document['playername'],
                          name2: document['opponentname'],
                          date: document['date'],
                          point1: document['point1'],
                          point2: document['point2'],
                          rate1: document['rate1'],
                          rate2: document['rate2'],
                          updated_rate1: document['updated_rate1'],
                          updated_rate2: document['updated_rate2']);
                    }).toList(),
                  );
                }
                return Center(
                  child: Text('読込中...'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
