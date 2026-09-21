import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProdutosPage extends StatelessWidget {
  const ProdutosPage({super.key});

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
                

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.builder(
                      padding: const EdgeInsets.only(bottom: 20),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: 6, 
                      itemBuilder: (context, index) {
                        return _buildCardProduto();
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

  Widget _buildCardProduto() {
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
                    Text('Nome do Produto', style: GoogleFonts.poppins(fontSize: 12), textAlign: TextAlign.center),
                    Text('Valor: 10.50', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ],
          ),
          
          // Etiqueta de quantidade
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
                '10 uni',
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
                
                TextField(
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
                const SizedBox(height: 24),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A3B5C), // Azul escuro
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _mostrarDialogSucesso(context);
                    },
                    child: Text(
                      'Salvar',
                      style: GoogleFonts.poppins(fontSize: 20, color: Colors.white),
                    ),
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
