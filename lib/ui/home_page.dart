import 'dart:convert';

import 'package:buscador_gifs/ui/gif_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

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
        title: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
                    child: Image.network(
                      'https://i.giphy.com/3oEjHYxjFSAxGFHAOs.webp',
                      height: 60,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Image.network(
                    'https://inovareti.eti.br/docs/imagens/ProjetoEmpresaBranco.png',
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: RichText(
                    text: const TextSpan(
                      text: 'Buscador de Gifs',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Pesquise aqui...',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
              //textCapitalization: TextCapitalization.sentences,
              onSubmitted: (text) {
                setState(() {
                  _searsh = text;
                  _offSet = 0;
                });
              },
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
                      child: const Image(
                        image: AssetImage('assets/images/searsh.webp'),
                      ),
                      // const CircularProgressIndicator(
                      //   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      //   strokeWidth: 5.0,
                      // ),
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
    _urlParamSearsh = {
      'api_key': dotenv.env['KEY'] ?? '',
      'q': _searsh,
      'limit': '25',
      'offset': _offSet.toString(),
      'rating': 'g',
      'lang': 'pt',
      'bundle': 'messaging_non_clips'
    };
    _urlParamTrending = {
      'api_key': dotenv.env['KEY'] ?? '',
      'limit': '25',
      'offset': _offSet.toString(),
      'rating': 'g',
      'bundle': 'messaging_non_clips'
    };
    http.Response response;
    if (_searsh == null || _searsh == '') {
      response = await http
          .get(Uri.https(_urlGifs, _urlPathTrending, _urlParamTrending));
    } else {
      response =
          await http.get(Uri.https(_urlGifs, _urlPathSearsh, _urlParamSearsh));
    }
    return json.decode(response.body);
  }

  int _getCount(List data) {
    if (_searsh == null || _searsh == '') {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGifTable(context, snapshot) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: _getCount(snapshot.data?['data']),
      itemBuilder: (context, index) {
        if (_searsh == null ||
            _searsh == '' ||
            index < snapshot.data?['data'].length) {
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: snapshot.data?['data'][index]['images']['fixed_height']['url'],
              height: 300.0,
              fit: BoxFit.cover,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return GifPage(gifData: snapshot.data?['data'][index]);
                  },
                ),
              );
            },
            onLongPress: () {
              Share.share(snapshot.data?['data'][index]['images']
                  ['fixed_height']['url']);
            },
          );
        } else {
          return Container(
            child: GestureDetector(
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 70.0,
                  ),
                  Text(
                    'Carregar mais...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                    ),
                  )
                ],
              ),
              onTap: () {
                setState(() {
                  _offSet += 25;
                });
              },
            ),
          );
        }
      },
    );
  }
}
