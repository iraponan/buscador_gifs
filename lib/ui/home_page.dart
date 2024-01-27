import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _searsh;
  int _offSet = 0;
  final String _urlGifs = dotenv.env['URL'] ?? '';
  final String _urlPathSearsh = dotenv.env['PATH_SEARSH'] ?? '';
  final String _urlPathTrending = dotenv.env['PATH_TRENDING'] ?? '';
  late Map<String, dynamic> _urlParamSearsh;
  late Map<String, dynamic> _urlParamTrending;

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future<Map> _getGifs() async {
    http.Response response;
    if (_searsh == null) {
      response = await http.get(Uri.https(_urlGifs, _urlPathTrending, _urlParamTrending));
    } else {
      response = await http.get(Uri.https(_urlGifs, _urlPathSearsh, _urlParamSearsh));
    }
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    _urlParamSearsh = {
      'api_key' : dotenv.env['KEY'] ?? '',
      'q' : _searsh,
      'limit' : '20',
      'offset' : '0',
      'rating' : 'g',
      'lang' : 'pt',
      'bundle' : 'messaging_non_clips'
    };
    _urlParamTrending = {
      'api_key' : dotenv.env['KEY'] ?? '',
      'limit' : '20',
      'offset' : _offSet.toString(),
      'rating' : 'g',
      'bundle' : 'messaging_non_clips'
    };
    _getGifs().then((map) => print(map));
  }
}
