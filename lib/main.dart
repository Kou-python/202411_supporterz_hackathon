import 'package:flutter/material.dart';
import 'category.dart';

void main() {
  runApp(MyApp());
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Text('グループ追加ボタン'),
      ),
    );
  }
}

//曲のカテゴリ検索
class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _controller =
      TextEditingController(); // 追加: 入力を管理するコントローラー

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TextFieldにコントローラーを設定
              Container(
                width: 300,
                child: TextField(
                  controller: _controller, // コントローラーを設定
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '知りたいカテゴリがあれば入力してください',
                  ),
                  autofocus: true,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('検索'),
                onPressed: () {
                  // 入力されたカテゴリを取得
                  String category = _controller.text;

                  // Categoryページに渡す
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Category(category), // 渡す
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              Text('♬みんなに聞かれている曲ランキング♬'),
              Container(
                width: 600,
                child: Table(
                  columnWidths: <int, TableColumnWidth>{
                    0: FixedColumnWidth(30),
                    1: FixedColumnWidth(300),
                    2: FixedColumnWidth(150),
                  },
                  border: TableBorder.all(),
                  children: [
                    for (int i = 0; i < 100; i++)
                      TableRow(
                        children: <Widget>[
                          Text('${i + 1}', textAlign: TextAlign.center),
                          Text("title", textAlign: TextAlign.center),
                          Text("artist", textAlign: TextAlign.center),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting'),
      ),
      body: Center(
        child: Text('Setting Page'),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Home(),
    Search(),
    Setting(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '検索',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '設定',
          ),
        ],
      ),
    );
  }
}
