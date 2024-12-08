import 'package:flutter/material.dart';
import 'category.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: GroupSelectionScreen(),
    );
  }
}

// 最初の画面
class GroupSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('グループ選択'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // グループ作成画面に遷移
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateGroupScreen()),
                );
              },
              child: Text('グループ作成'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // グループに入る画面に遷移
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JoinGroupScreen()),
                );
              },
              child: Text('グループに入る'),
            ),
          ],
        ),
      ),
    );
  }
}

// グループ作成画面
class CreateGroupScreen extends StatefulWidget {
  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // グループ作成ボタンが押された時の処理
  void _createGroup() {
    final groupName = _groupNameController.text;
    final password = _passwordController.text;

    if (groupName.isNotEmpty && password.isNotEmpty) {
      // 入力が正しい場合、Home画面に遷移
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomeScreen(groupName: groupName)),
      );
    } else {
      // 入力が不正な場合
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('グループ名とパスワードを入力してください')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('グループ作成'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _groupNameController,
              decoration: InputDecoration(
                labelText: 'グループ名',
                hintText: 'グループの名前を入力してください',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'パスワード',
                hintText: 'グループのパスワードを入力してください',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createGroup,
              child: Text('グループを作成'),
            ),
          ],
        ),
      ),
    );
  }
}

// グループに入る画面
class JoinGroupScreen extends StatefulWidget {
  @override
  _JoinGroupScreenState createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends State<JoinGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // グループに入るボタンが押された時の処理
  void _joinGroup() {
    final groupName = _groupNameController.text;
    final password = _passwordController.text;

    if (groupName.isNotEmpty && password.isNotEmpty) {
      // グループに入る処理（仮）
      // ここでグループ名とパスワードの照合を行い、正しければHome画面に遷移
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomeScreen(groupName: groupName)),
      );
    } else {
      // 入力が不正な場合
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('グループ名とパスワードを入力してください')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('グループに入る'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _groupNameController,
              decoration: InputDecoration(
                labelText: 'グループ名',
                hintText: 'グループ名を入力してください',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'パスワード',
                hintText: 'グループのパスワードを入力してください',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _joinGroup,
              child: Text('グループに入る'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String groupName;

  // コンストラクタでグループ名を受け取る
  HomeScreen({required this.groupName});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    GroupHomePage(),
    Search(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group: ${widget.groupName}'), // グループ名を表示
      ),
      body: _pages[_currentIndex], // 現在のページを表示
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: '曲選択',
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

class GroupHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('笹川高聖'),
          Text('滝本陽也'),
          Text('土田勇斗'),
          Text('土屋彩音'),
          Text('山口瑞月'),
        ],
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

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('設定ページ'),
    );
  }
}
