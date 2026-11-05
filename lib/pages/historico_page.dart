import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../repositories/produto_repository.dart';

class HistoricoPage extends StatefulWidget {
  const HistoricoPage({super.key});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  DateTime _dataSelecionada = DateTime.now();
  final ProdutoRepository _repository = ProdutoRepository();
  List _transacoes = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarTransacoes(); // Carrega as transações do dia atual ao abrir a página
  }

  Future<void> _carregarTransacoes() async {
    setState(() => _carregando = true);
    
    // Extrai a data no formato "YYYY-MM-DD" para o SQLite procurar corretamente
    String dataFormatada = _dataSelecionada.toIso8601String().split('T')[0];
    
    final transacoes = await _repository.getTransacoesPorData(dataFormatada);
    
    setState(() {
      _transacoes = transacoes;
      _carregando = false;
    });
  }

  // Define um ícone dependendo de como a pessoa pagou
  IconData _getIconePagamento(String? metodo) {
    if (metodo == 'Pix') return Icons.pix;
    if (metodo == 'Cartão') return Icons.credit_card;
    if (metodo == 'Dinheiro') return Icons.attach_money;
    return Icons.receipt; // Ícone padrão
  }

  // Define a cor do ícone
  Color _getCorPagamento(String? metodo) {
    if (metodo == 'Pix') return Colors.teal;
    if (metodo == 'Cartão') return Colors.orange;
    if (metodo == 'Dinheiro') return Colors.green;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text('Histórico', style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: const Color(0xFF1E3A8A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: CalendarDatePicker(
              initialDate: _dataSelecionada,
              firstDate: DateTime(2024),
              lastDate: DateTime.now(),
              onDateChanged: (novaData) {
                setState(() {
                  _dataSelecionada = novaData;
                });
                _carregarTransacoes(); // Atualiza a lista quando clica noutra data!
              },
            ),
          ),
          const SizedBox(height: 10),
          
          Expanded(
            child: _carregando 
                ? const Center(child: CircularProgressIndicator())
                : _transacoes.isEmpty
                    ? Center(
                        child: Text(
                          'Nenhuma venda no dia ${_dataSelecionada.day}/${_dataSelecionada.month}/${_dataSelecionada.year}.',
                          style: GoogleFonts.poppins(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: _transacoes.length,
                        itemBuilder: (context, index) {
                          final transacao = _transacoes[index];
                          final nome = transacao['nome_produto'];
                          final quantidade = transacao['quantidade_vendida'];
                          final valor = transacao['valor_total'] as double;
                          final metodo = transacao['metodo_pagamento'] ?? 'Desconhecido';
                          
                          // Formata a hora para mostrar apenas HH:MM
                          String horaStr = transacao['hora']?.toString() ?? '--:--';
                          if (horaStr.length >= 5) {
                            horaStr = horaStr.substring(0, 5);
                          }

                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              leading: CircleAvatar(
                                backgroundColor: _getCorPagamento(metodo).withOpacity(0.2),
                                child: Icon(_getIconePagamento(metodo), color: _getCorPagamento(metodo)),
                              ),
                              title: Text(
                                nome, 
                                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)
                              ),
                              subtitle: Text(
                                '$horaStr • Pago no $metodo\nQtd: $quantidade', 
                                style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54)
                              ),
                              trailing: Text(
                                'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 16,
                                  color: const Color(0xFF1E3A8A)
                                )
                              ),
                              isThreeLine: true,
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}