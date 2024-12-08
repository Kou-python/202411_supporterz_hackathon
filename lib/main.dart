import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'spotify_service.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // keyパラメータを追加

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Top Tracks'), // constを追加
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});// keyパラメータを追加

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState(); // クラス名の先頭のアンダースコアを削除
}

class MyHomePageState extends State<MyHomePage> { // クラス名の先頭のアンダースコアを削除
  final SpotifyService _spotifyService = SpotifyService();
  List<dynamic> _topTracks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTopTracks();
  }

  Future<void> _fetchTopTracks() async {
    final data = await _spotifyService.getTopTracks();
    setState(() {
      _topTracks = data['items'];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemCount: _topTracks.length,
                itemBuilder: (context, index) {
                  final track = _topTracks[index];
                  return ListTile(
                    leading: track['album']['images'].isNotEmpty
                        ? Image.network(track['album']['images'][0]['url'])
                        : const Icon(Icons.music_note),
                    title: Text(track['name']),
                    subtitle: Text('Artist: ${track['artists'][0]['name']}'),
                  );
                },
              ),
      ),
    );
  }
}