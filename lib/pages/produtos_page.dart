import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/produto_model.dart';
import '../repositories/produto_repository.dart';

class ProdutosPage extends StatefulWidget {
  const ProdutosPage({super.key});

  @override
  State<ProdutosPage> createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage> {
  final _nomeController = TextEditingController();
  final _quantidadeController = TextEditingController();
  final _valorController = TextEditingController(); 

  final _repository = ProdutoRepository();
  
  List<Produto> _produtos = [];

  @override
  void initState() {
    super.initState();
    _carregarProdutos();
  }

  Future<void> _carregarProdutos() async {
    final lista = await _repository.listarProdutos();
    setState(() {
      _produtos = lista;
    });
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _quantidadeController.dispose();
    _valorController.dispose();
    super.dispose();
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
              errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFF1E3A8A)),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                _buildCabecalho(),
                _buildCardAdicionar(context),
                _buildBotaoPesquisa(),
                

                // Grelha de produtos
                // Grelha de produtos
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _produtos.isEmpty 
                      ? Center(
                          child: Text(
                            'Nenhum produto cadastrado ainda !',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.pacifico(
                              fontSize: 40, 
                              color: Colors.white,
                            ),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.only(bottom: 20),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: _produtos.length,
                          itemBuilder: (context, index) {
                            final produto = _produtos[index];
                            return _buildCardProduto(produto);
                          },
                        ),
                  ),
                ),
              ],
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
              print("Abrir configurações de perfil");
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

  Widget _buildCardAdicionar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _mostrarDialogAdicionar(context);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF1A3B5C), width: 1.5),
              ),
              child: const Icon(Icons.add, color: Color(0xFF1A3B5C), size: 24),
            ),
            const SizedBox(width: 12),
            Text(
              'Adicionar Novo Produto',
              style: GoogleFonts.poppins(
                fontSize: 20, 
                color: const Color(0xFF1A3B5C),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBotaoPesquisa() {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, bottom: 16.0),
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

  Widget _buildCardProduto(Produto produto) {
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
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  ),
                  child: const Icon(Icons.image, size: 50, color: Colors.grey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      produto.nome, 
                      style: GoogleFonts.poppins(fontSize: 12), 
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Valor: ${produto.valor.toStringAsFixed(2)}', 
                      style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          ),
          
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.black45, width: 0.5),
              ),
              child: Text(
                '${produto.quantidade} uni',
                style: GoogleFonts.poppins(fontSize: 10, color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogAdicionar(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: const Color(0xFFD4D8DD), 
          insetPadding: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, 
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Adicionar produto',
                      style: GoogleFonts.pacifico(fontSize: 26, color: const Color(0xFF1E3A8A)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 28, color: Color(0xFF1E3A8A)),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Icon(Icons.add_photo_alternate_outlined, size: 40, color: Colors.black26),
                  ),
                ),
                const SizedBox(height: 20),
                
                TextField(
                  controller: _nomeController, 
                  decoration: InputDecoration(
                    hintText: 'Nome',
                    hintStyle: GoogleFonts.poppins(color: Colors.black38),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                //Quantidade e Valor lado a lado
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _quantidadeController, 
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Quantidade',
                          hintStyle: GoogleFonts.poppins(color: Colors.black38),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _valorController, 
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          hintText: 'Valor (R\$)',
                          hintStyle: GoogleFonts.poppins(color: Colors.black38),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Botão Salvar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A3B5C),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () async {
                      final novoProduto = Produto(
                        nome: _nomeController.text,
                        quantidade: int.tryParse(_quantidadeController.text) ?? 0,
                        valor: double.tryParse(_valorController.text.replaceAll(',', '.')) ?? 0.0,
                      );

                      await _repository.cadastrarProduto(novoProduto);

                      _nomeController.clear();
                      _quantidadeController.clear();
                      _valorController.clear();

                      _carregarProdutos();

                      if (context.mounted) {
                        Navigator.pop(context); 
                        _mostrarDialogSucesso(context); 
                      }
                    },
                    child: Text('Salvar', style: GoogleFonts.poppins(fontSize: 20, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _mostrarDialogSucesso(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: const Color(0xFFD4D8DD),
          insetPadding: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 28, color: Colors.black87),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Produto\ncadastrado\ncom sucesso!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.pacifico(
                    fontSize: 38,
                    color: const Color(0xFF1E3A8A),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }
}
