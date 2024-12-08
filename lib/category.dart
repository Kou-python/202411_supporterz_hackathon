import 'package:flutter/material.dart';

//カテゴリ分けした際の結果を表示
class Category extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category'),
      ),
      body: Center(
        // child: Text('Search Page'),
        child: TextField(),
      ),
    );
  }
}
