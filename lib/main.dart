import 'package:chat_bot/Screen/Home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

// ignore: constant_identifier_names
const api_key = 'AIzaSyCz1JNUYZElH-NRq91Ly7nIF-oTKzMahKk';

void main() {
  Gemini.init(apiKey: api_key);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'chat bubble example',
      theme: ThemeData.dark().copyWith(),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}
