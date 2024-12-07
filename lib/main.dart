import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'spotify_service.dart';
void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class SpotifyLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spotify Login'),
      ),
      body: Center(
        child: Text('Spotify Login Page'),
      ),
    );
  }
}

class ApiDataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Data Page'),
      ),
      body: Center(
        child: Text('API Data Page'),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Text('Home Page'),
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
      home: MyHomePage(title: 'Top Tracks'),
    );
  }
}

class MyHomePage extends StatefulWidget {
    const MyHomePage({super.key, required this.title});

  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}


// class _MyHomePageState extends State<MyHomePage> {
//   int _currentIndex = 0;

//   final List<Widget> _pages = [
//     SpotifyLoginPage(),
//     HomePage(),
//     ApiDataPage(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.login),
//             label: 'Login',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.data_usage),
//             label: 'API Data',
//           ),
//         ],
//       ),
//     );
//   }
// }
class _MyHomePageState extends State<MyHomePage> {
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