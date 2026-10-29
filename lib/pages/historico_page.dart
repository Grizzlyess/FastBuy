import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoricoPage extends StatefulWidget {
  const HistoricoPage({super.key});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  DateTime _dataSelecionada = DateTime.now();
  

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
              },
            ),
          ),
          const SizedBox(height: 10),
          
          Expanded(
            child: Center(
              child: Text(
                'Buscando transações de ${_dataSelecionada.day}/${_dataSelecionada.month}...',
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}