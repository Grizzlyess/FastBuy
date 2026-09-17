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
      debugShowCheckedModeBanner: false,
      title: 'FastBuy',
      home: const LoginPage(), 
    );
  }
}