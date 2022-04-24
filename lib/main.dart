import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'layout/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'todo app',
      home: HomeScreen(),
    );
  }
}


