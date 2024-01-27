import 'package:buscador_gifs/ui/gif_page.dart';
import 'package:buscador_gifs/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
    theme: ThemeData(
      hintColor: Colors.white,
    ),
  ));
}
