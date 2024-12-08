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

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _controller = TextEditingController();

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
                  String category = _controller.text;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Category(category),
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
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _gender;
  int? _age;
  String? _favoriteGenre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('設定'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: '名前'),
                onSaved: (value) {
                  _name = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '名前を入力してください';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: '性別'),
                items: ['男性', '女性', 'その他'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  _gender = newValue;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '性別を選択してください';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '年齢'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _age = int.tryParse(value!);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '年齢を入力してください';
                  }
                  if (int.tryParse(value) == null) {
                    return '有効な年齢を入力してください';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: '好きなジャンル'),
                items: ['ポップ', 'ロック', 'クラシック', 'ジャズ'] .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  _favoriteGenre = newValue;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ジャンルを選択してください';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // 設定を処理するロジックをここに追加
                  }
                },
                child: Text('保存'),
              ),
            ],
          ),
        ),
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
