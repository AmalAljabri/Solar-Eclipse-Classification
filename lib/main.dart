import 'package:sec_app/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solar Eclipse Classification App',
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
