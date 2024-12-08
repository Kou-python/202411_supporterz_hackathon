import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'spotify_service.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotify Token Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TokenPage(),
    );
  }
}

class TokenPage extends StatefulWidget {
  @override
  _TokenPageState createState() => _TokenPageState();
}

class _TokenPageState extends State<TokenPage> {
  final SpotifyService _spotifyService = SpotifyService();
  String? _accessToken;

  Future<void> _getAccessToken() async {
    try {
      final token = await _spotifyService.getAccessToken();
      setState(() {
        _accessToken = token;
      });
    } catch (e) {
      setState(() {
        _accessToken = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Spotify Token')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _accessToken ?? 'Press the button to get the access token.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getAccessToken,
              child: Text('Get Access Token'),
            ),
          ],
        ),
      ),
    );
  }
}
