import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Rankings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context);
    final User user = userState.user!;
    return Container(
      padding: EdgeInsets.only(top: 48),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _RankingsHeader(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .orderBy('rating', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                // データが取得できた場合
                if (snapshot.hasData) {
                  final List<DocumentSnapshot> documents = snapshot.data!.docs;
                  return ListView(
                    children: documents.asMap().entries.map((document) {
                      return _Rank(
                        name: document.value['name'],
                        rating: document.value['rating'],
                        ranking: document.key + 1,
                      );
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

class _RankingsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          "ランキング",
          style: TextStyle(
            fontSize: 30,
            fontFamily: 'KosugiMaru',
          ),
        ));
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
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'KosugiMaru'),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(
                name,
                style: TextStyle(fontFamily: 'KosugiMaru'),
              ),
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
