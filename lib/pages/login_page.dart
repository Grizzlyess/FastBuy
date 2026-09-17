import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; 

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset('assets/fundo.png', fit: BoxFit.cover),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        Image.asset(
                        'assets/logo.png', 
                        height: 50, 
                        ),
                        const SizedBox(height: 24),
                        
                        Text(
                        'Olá!',
                        style: GoogleFonts.pacifico(
                            fontSize: 48, 
                            color: Colors.white,
                        ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                        'Bem-vindo ao FastBuy',
                        style: GoogleFonts.poppins(fontSize: 18, color: Colors.white70),
                        ),
                        
                        const SizedBox(height: 60),
                        
                        // --- CARD CINZA CLARO E ESTRELAS ---
                        Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topCenter,
                        children: [
                            Container(
                            margin: const EdgeInsets.only(top: 30),
                            padding: const EdgeInsets.fromLTRB(32, 50, 32, 150),
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
                                    'Login',
                                    style: GoogleFonts.pacifico(
                                        fontSize: 48, 
                                        color: const Color(0xFF1E3A8A)
                                    ),
                                    ),
                                ),
                                const SizedBox(height: 24),
                                
                                // Campo de Email
                                TextField(
                                    decoration: InputDecoration(
                                    labelText: 'Email',
                                    filled: true,
                                    fillColor: Colors.white,
                                    
                                
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30), 
                                        borderSide: const BorderSide(
                                        color: Color(0xFF1E3A8A), 
                                        width: 1.5, 
                                        ),
                                    ),
                                    

                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                        color: Color(0xFF1E3A8A),
                                        width: 2.0, 
                                        ),
                                    ),
                                    ),
                                ),
                                const SizedBox(height: 16),
                                
                                // Campo de Senha
                                TextField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                    labelText: 'Senha',
                                    filled: true,
                                    fillColor: Colors.white,
                                    
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                        color: Color(0xFF1E3A8A),
                                        width: 1.5,
                                        ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                        color: Color(0xFF1E3A8A),
                                        width: 2.0,
                                        ),
                                    ),
                                    ),
                                ),
                                
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(onPressed: () {}, child: Text('Esqueci minha senha', style: GoogleFonts.poppins(color: const Color(0xFF1E3A8A)))),
                                ),
                                const SizedBox(height: 16),
                                
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1A1F36),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    ),
                                    onPressed: () {},
                                    child: Text('Login', style: GoogleFonts.poppins(fontSize: 18, color: Colors.white)),
                                ),
                                
                                const SizedBox(height: 8),
                                Center(child: TextButton(onPressed: () {}, child: Text('Primeira vez? Criar conta', style: GoogleFonts.poppins(color: const Color(0xFF1E3A8A))))),
                                const SizedBox(height: 40),
                                ],
                            ),
                            ),
                            

                            // As Estrelas 
                            Positioned(
                            top: 0, 
                            left: 0,
                            right: 0,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                Image.asset('assets/estrelas.png', height: 80),
                                Image.asset('assets/estrelas.png', height: 80),
                                Image.asset('assets/estrelas.png', height: 80),
                                Image.asset('assets/estrelas.png', height: 80),
                                ],
                            ),
                            ),
                        ],
                        ),
                    ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}