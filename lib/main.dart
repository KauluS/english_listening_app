import 'package:flutter/material.dart';
import 'screens/listening_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'リスニング練習',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ListeningScreen(),
    );
  }
}
