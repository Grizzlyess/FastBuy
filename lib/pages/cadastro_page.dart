import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../database/database_helper.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _estabelecimentoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _repitaSenhaController = TextEditingController();

  void _realizarCadastro() async {
    String nome = _nomeController.text;
    String estabelecimento = _estabelecimentoController.text;
    String email = _emailController.text;
    String senha = _senhaController.text;
    String repitaSenha = _repitaSenhaController.text;

    if (nome.isEmpty || estabelecimento.isEmpty || email.isEmpty || senha.isEmpty || repitaSenha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos!')),
      );
      return;
    }

    if (senha != repitaSenha) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem!')),
      );
      return;
    }

    // O banco precisará ser atualizado no futuro para salvar o "estabelecimento"
    await DatabaseHelper.instance.cadastrarUsuario(nome, email, senha);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário cadastrado com sucesso!')),
      );
      Navigator.pop(context); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //FUNDO
          Positioned.fill(
            child: Image.asset(
              'assets/fundo.png', 
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFF1E3A8A)),
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  
                  // LOGO
                  Text(
                    '🚀FastBuy🚀',
                    style: GoogleFonts.pacifico(
                      fontSize: 42,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // CAIXA CINZA DO FORMULÁRIO
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 30), // Espaço para as estrelas
                        padding: const EdgeInsets.fromLTRB(32, 60, 32, 150),
                        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                        decoration: const BoxDecoration(
                          color: Color(0xFFEAEAEA),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: Text(
                                'Cadastre-se',
                                style: GoogleFonts.pacifico(
                                  fontSize: 42,
                                  color: const Color(0xFF1E3A8A),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),

                            _buildTextField('Nome', _nomeController),
                            const SizedBox(height: 16),
                            
                            _buildTextField('Nome do estabelecimento', _estabelecimentoController),
                            const SizedBox(height: 16),
                            
                            _buildTextField('Email', _emailController),
                            const SizedBox(height: 16),
                            
                            _buildTextField('Senha', _senhaController, obscureText: true),
                            const SizedBox(height: 16),

                            _buildTextField('Repita a senha', _repitaSenhaController, obscureText: true),
                            const SizedBox(height: 32),
                            
                            ElevatedButton(
                              onPressed: _realizarCadastro,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E3A8A),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                'Cadastrar',
                                style: TextStyle(fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // ESTRELAS 
                      Positioned(
                        top: -10,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildEstrelaSegura(),
                            _buildEstrelaSegura(),
                            _buildEstrelaSegura(),
                            _buildEstrelaSegura(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black45),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 2.0),
        ),
      ),
    );
  }

  Widget _buildEstrelaSegura() {
    return Image.asset(
      'assets/estrelas.png', 
      height: 80,
      errorBuilder: (context, error, stackTrace) => const SizedBox(height: 80, width: 80),
    );
  }
}