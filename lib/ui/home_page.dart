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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            'https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif'),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Pesquise Aqui',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      alignment: Alignment.center,
                      width: 200.0,
                      height: 200.0,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Container();
                    } else {
                      return _createGifTable(context, snapshot);
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<Map> _getGifs() async {
    http.Response response;
    if (_searsh == null) {
      response = await http
          .get(Uri.https(_urlGifs, _urlPathTrending, _urlParamTrending));
    } else {
      response =
          await http.get(Uri.https(_urlGifs, _urlPathSearsh, _urlParamSearsh));
    }
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    _urlParamSearsh = {
      'api_key': dotenv.env['KEY'] ?? '',
      'q': _searsh,
      'limit': '20',
      'offset': '0',
      'rating': 'g',
      'lang': 'pt',
      'bundle': 'messaging_non_clips'
    };
    _urlParamTrending = {
      'api_key': dotenv.env['KEY'] ?? '',
      'limit': '20',
      'offset': _offSet.toString(),
      'rating': 'g',
      'bundle': 'messaging_non_clips'
    };
    _getGifs().then((map) => print(map));
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot<Map<dynamic, dynamic>> snapshot) {

  }
}
