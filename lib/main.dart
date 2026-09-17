import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const FastBuyApp());
}

class FastBuyApp extends StatelessWidget {
  const FastBuyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FastBuy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1E3A8A),
      ),
      home: LoginPage(), 
    );
  }
}