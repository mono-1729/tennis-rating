import 'main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
