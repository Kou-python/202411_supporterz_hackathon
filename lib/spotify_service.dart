import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;

class SpotifyService {
  final String _clientId = dotenv.env['SPOTIFY_CLIENT_ID']!;
  final String _clientSecret = dotenv.env['SPOTIFY_CLIENT_SECRET']!;
  final String _redirectUri = dotenv.env['SPOTIFY_REDIRECT_URI']!;
  String? _accessToken;

  Future<String> getAccessToken() async {
    if (_accessToken != null) {
      return _accessToken!;
    }

    // Spotify認証URLを生成
    final authUrl = Uri.https('accounts.spotify.com', '/authorize', {
      'response_type': 'code',
      'client_id': _clientId,
      'redirect_uri': _redirectUri,
      'scope': 'user-top-read', // トップトラック権限（不要なら削除可）
    });

    try {
      // 認証を開始し、結果を取得
      final result = await FlutterWebAuth.authenticate(
        url: authUrl.toString(),
        callbackUrlScheme: 'http', // 適切なスキームに変更
      );
      
      final code = Uri.parse(result).queryParameters['code'];
      if (code == null) {
        throw Exception('Authorization code is null');
      }
      print('Authorization callback result: $result');
      // トークン取得リクエスト
      final response = await http.post(
        Uri.parse('https://accounts.spotify.com/api/token'),
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('$_clientId:$_clientSecret'))}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': _redirectUri,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _accessToken = data['access_token'];
        return _accessToken!;
      } else {
        throw Exception('Failed to get access token: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error during authentication: $e');
    }
  }

  // トップトラックを取得するメソッドを追加
  Future<Map<String, dynamic>> getTopTracks() async {
    final accessToken = await getAccessToken(); // アクセストークンを取得
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/me/top/tracks'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load top tracks');
    }
  }
}