import 'package:flutter/material.dart';
import 'produtos_page.dart';
// import 'carrinho_page.dart';
// import 'relatorios_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _indiceAtual = 0;


  final List<Widget> _paginas = [
    const ProdutosPage(),
    const Center(child: Text('Página do Carrinho (Em breve)')),
    const Center(child: Text('Página de Relatórios (Em breve)')),
  ];

  void _aoTocarNaAba(int index) {
    setState(() {
      _indiceAtual = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAEAEA),
      body: _paginas[_indiceAtual],
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        onTap: _aoTocarNaAba,
        backgroundColor: const Color(0xFFE0E0E0),
        selectedItemColor: const Color(0xFF1E3A8A),
        unselectedItemColor: Colors.black45,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 32,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: 'Produtos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Carrinho',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            activeIcon: Icon(Icons.stacked_line_chart),
            label: 'Relatórios',
          ),
        ],
      ),
    );
  }
}