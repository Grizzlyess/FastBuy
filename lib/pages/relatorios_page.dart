import 'package:fastbuy/pages/historico_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/produto_model.dart';
import '../repositories/produto_repository.dart';

class RelatoriosPage extends StatefulWidget {
  const RelatoriosPage({super.key});

  @override
  State<RelatoriosPage> createState() => _RelatoriosPageState();
}

class _RelatoriosPageState extends State<RelatoriosPage> {
  final _repository = ProdutoRepository();
  List<Produto> _produtos = [];

  // Listas para os relatórios
  List<Map<String, dynamic>> _maisVendidos = [];
  List<Map<String, dynamic>> _menosVendidos = [];
  List<Map<String, dynamic>> _faturamentoDias = [];
  List<Map<String, dynamic>> _faturamentoSemanas = [];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final listaProdutos = await _repository.listarProdutos();
    final topMais = await _repository.getTop5MaisVendidos();
    final topMenos = await _repository.getTop5MenosVendidos();
    final fatDias = await _repository.getFaturamentoUltimos5Dias();
    final fatSemanas = await _repository.getFaturamentoUltimas5Semanas();

    setState(() {
      _produtos = listaProdutos;
      _maisVendidos = topMais;
      _menosVendidos = topMenos;
      _faturamentoDias = fatDias;
      _faturamentoSemanas = fatSemanas;
    });
  }

  int get _totalTiposProdutos => _produtos.length;
  int get _totalItensFisicos => _produtos.fold(0, (total, item) => total + item.quantidade);
  double get _valorTotalEstoque => _produtos.fold(0, (total, item) => total + (item.quantidade * item.valor));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
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
                _buildCabecalho(context),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            'Visão Geral do Estoque',
                            style: GoogleFonts.pacifico(fontSize: 26, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: [
                              _buildCardMetrica('Valor em Estoque', 'R\$ ${_valorTotalEstoque.toStringAsFixed(2).replaceAll('.', ',')}', Icons.attach_money, Colors.green),
                              const SizedBox(height: 12),
                              _buildCardMetrica('Total de Itens', '$_totalItensFisicos unidades', Icons.inventory_2_outlined, Colors.orange),
                              const SizedBox(height: 12),
                              _buildCardMetrica('Variedade', '$_totalTiposProdutos produtos', Icons.category_outlined, Colors.blue),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        
                        // ÁREA DE LISTAS DE HISTÓRICO
                        Container(
                            width: double.infinity,
                            constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height * 0.6, // Força a esticar até ao fundo
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                            ),
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildTituloSecao('Top 5 Mais Vendidos', Icons.trending_up),
                              _buildListaHistorico(_maisVendidos, 'nome_produto', 'total', 'unidades'),
                              const SizedBox(height: 24),
                              
                              _buildTituloSecao('Top 5 Menos Vendidos', Icons.trending_down),
                              _buildListaHistorico(_menosVendidos, 'nome_produto', 'total', 'unidades'),
                              const SizedBox(height: 24),

                              _buildTituloSecao('Faturamento: Últimos 5 Dias', Icons.calendar_today),
                              _buildListaHistorico(_faturamentoDias, 'data', 'total', 'R\$', isMonetario: true),
                              const SizedBox(height: 24),

                              _buildTituloSecao('Faturamento: Últimas 5 Semanas', Icons.date_range),
                              _buildListaHistorico(_faturamentoSemanas, 'semana', 'total', 'R\$', isMonetario: true, prefixoChave: 'Semana '),
                            ],
                          ),
                        ),
                      ],
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

  /*Widget _buildCabecalho() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('🚀FastBuy🚀', style: GoogleFonts.pacifico(color: Colors.white, fontSize: 24)),
          const CircleAvatar(backgroundColor: Colors.white, radius: 20, child: Icon(Icons.person, color: Color(0xFF1E3A8A))),
        ],
      ),
    );
  }*/

  Widget _buildCabecalho(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '🚀FastBuy🚀',
            style: GoogleFonts.pacifico(color: Colors.white, fontSize: 24),
          ),
          Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: PopupMenuButton<String>(
              offset: const Offset(0, 50),
              color: const Color(0xFF1A1F30), 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                // AQUI: Contorno da caixinha agora é totalmente BRANCO
                side: const BorderSide(color: Colors.white, width: 1.5),
              ),
              // A bolinha do perfil padrão (Branca com boneco azul)
              icon: const CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Color(0xFF1E3A8A), size: 28),
              ),
              onSelected: (String valor) {
                if (valor == 'historico') {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoricoPage()));
                } else if (valor == 'nome') {
                  print("Ação: Mudar Nome");
                } else if (valor == 'foto') {
                  print("Ação: Trocar Foto");
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  enabled: false,
                  child: Center(
                    child: Text(
                      'Nome', // Texto padrão sem nome
                      style: GoogleFonts.pacifico(color: Colors.white, fontSize: 22),
                    ),
                  ),
                ),
                const PopupMenuDivider(height: 1),
                PopupMenuItem<String>(
                  value: 'nome',
                  child: Row(
                    children: [
                      const Icon(Icons.store, color: Colors.white, size: 20),
                      const SizedBox(width: 12),
                      Text('Mudar Nome', style: GoogleFonts.poppins(color: Colors.white)),
                    ],
                  ),
                ),
                const PopupMenuDivider(height: 1),
                PopupMenuItem<String>(
                  value: 'foto',
                  child: Row(
                    children: [
                      const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      const SizedBox(width: 12),
                      Text('Trocar Foto', style: GoogleFonts.poppins(color: Colors.white)),
                    ],
                  ),
                ),
                const PopupMenuDivider(height: 1),
                PopupMenuItem<String>(
                  value: 'historico',
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month, color: Colors.white, size: 20),
                      const SizedBox(width: 12),
                      Text('Histórico de Vendas', style: GoogleFonts.poppins(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardMetrica(String titulo, String valor, IconData icone, Color corIcone) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: corIcone.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icone, size: 28, color: corIcone),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600])),
                Text(valor, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF1E3A8A))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTituloSecao(String titulo, IconData icone) {
    return Row(
      children: [
        Icon(icone, color: const Color(0xFF1E3A8A), size: 22),
        const SizedBox(width: 10),
        Text(titulo, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: const Color(0xFF1E3A8A))),
      ],
    );
  }

  Widget _buildListaHistorico(List<Map<String, dynamic>> dados, String chavePrincipal, String chaveValor, String sufixo, {bool isMonetario = false, String prefixoChave = ''}) {
    if (dados.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Text('Ainda não há dados suficientes.', style: GoogleFonts.poppins(color: Colors.grey, fontStyle: FontStyle.italic)),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dados.length,
      separatorBuilder: (context, index) => Divider(color: Colors.grey[300]),
      itemBuilder: (context, index) {
        final item = dados[index];
        final nome = '$prefixoChave${item[chavePrincipal] ?? 'Desconhecido'}';
        final valorCru = item[chaveValor];
        
        String valorFormatado;
        if (isMonetario) {
          valorFormatado = '$sufixo ${(valorCru as num).toStringAsFixed(2).replaceAll('.', ',')}';
        } else {
          valorFormatado = '$valorCru $sufixo';
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(nome, style: GoogleFonts.poppins(fontSize: 15, color: Colors.black87)),
              Text(valorFormatado, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF1E3A8A))),
            ],
          ),
        );
      },
    );
  }
}