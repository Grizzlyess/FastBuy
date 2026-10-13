import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/produto_model.dart';
import '../repositories/produto_repository.dart';
import 'dart:io';

// Classe auxiliar para gerir a quantidade do produto na venda
class ItemVenda {
  final Produto produto;
  int quantidadeSelecionada;

  ItemVenda({required this.produto, this.quantidadeSelecionada = 0});
}

class CarrinhoPage extends StatefulWidget {
  const CarrinhoPage({super.key});

  @override
  State<CarrinhoPage> createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage> {
  final _repository = ProdutoRepository();
  List<ItemVenda> _itensVenda = [];

  @override
  void initState() {
    super.initState();
    _carregarProdutos();
  }

  Future<void> _carregarProdutos() async {
    final lista = await _repository.listarProdutos();
    setState(() {
      _itensVenda = lista.map((p) => ItemVenda(produto: p)).toList();
    });
  }

  double get _totalVenda {
    return _itensVenda.fold(
        0, (total, item) => total + (item.produto.valor * item.quantidadeSelecionada));
  }

  void _alterarQuantidade(int index, int delta) {
    setState(() {
      final novaQuantidade = _itensVenda[index].quantidadeSelecionada + delta;
      if (novaQuantidade >= 0 && novaQuantidade <= _itensVenda[index].produto.quantidade) {
        _itensVenda[index].quantidadeSelecionada = novaQuantidade;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // 1. FUNDO DA APLICAÇÃO
          Positioned.fill(
            child: Image.asset(
              'assets/fundo.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: const Color(0xFF1E3A8A)),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildCabecalho(),
                
                // CARD DE TOTAL DA VENDA
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text('Total da Venda:',
                          style: GoogleFonts.poppins(
                              fontSize: 20, fontWeight: FontWeight.w500)),
                      Text(
                        'R\$ ${_totalVenda.toStringAsFixed(2).replaceAll('.', ',')}',
                        style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E3A8A)),
                      ),
                    ],
                  ),
                ),

                _buildBotaoPesquisa(),

                // Grelha de produtos
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _itensVenda.isEmpty
                        ? Center(
                            child: Text(
                              'Estoque vazio!',
                              style: GoogleFonts.pacifico(
                                fontSize: 30,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.only(bottom: 120), // Espaço para não ficar por baixo do painel do carrinho
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: _itensVenda.length,
                            itemBuilder: (context, index) {
                              return _buildCardProdutoVenda(index);
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),

          // PAINEL FIXO DO CARRINHO EM BAIXO
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 120, // Altura fixa para não causar overflow
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 24), // Espaçador para centrar o texto
                        Text(
                          'Carrinho',
                          style: GoogleFonts.pacifico(
                              fontSize: 28, color: const Color(0xFF1E3A8A)),
                        ),
                        const Icon(Icons.menu, color: Color(0xFF1E3A8A), size: 28),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A3B5C),
                        minimumSize: const Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                      ),
                      onPressed: _totalVenda > 0 ? () {} : null,
                      child: Text('Finalizar',
                          style: GoogleFonts.poppins(
                              fontSize: 20, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCabecalho() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '🚀FastBuy🚀',
            style: GoogleFonts.pacifico(color: Colors.white, fontSize: 24),
          ),
          GestureDetector(
            onTap: () {
              print("Abrir perfil a partir do carrinho");
            },
            child: const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20,
              child: Icon(Icons.person, color: Color(0xFF1E3A8A)), 
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotaoPesquisa() {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, bottom: 10.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.search, color: Colors.black54),
            onPressed: () {},
          ),
        ),
      ),
    );
  }

  Widget _buildCardProdutoVenda(int index) {
    final item = _itensVenda[index];
    
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(15)),
                  ),
                  child: item.produto.imagemPath != null && item.produto.imagemPath!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                          child: Image.file(
                            File(item.produto.imagemPath!),
                            fit: BoxFit.contain, // Modificado para imagem caber toda
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image, size: 50, color: Colors.grey),
                          ),
                        )
                      : const Icon(Icons.image, size: 50, color: Colors.grey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      item.produto.nome,
                      style: GoogleFonts.poppins(fontSize: 12),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Valor: ${item.produto.valor.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          ),
          // CONTROLO DE QUANTIDADE (Canto Superior Direito)
          Positioned(
            top: 5,
            right: 5,
            child: Container(
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black26),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => _alterarQuantidade(index, -1),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Icon(Icons.remove_circle_outline, size: 16, color: Colors.black54),
                    ),
                  ),
                  Text(
                    '${item.quantidadeSelecionada}',
                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () => _alterarQuantidade(index, 1),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Icon(Icons.add_circle_outline, size: 16, color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}