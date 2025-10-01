// class_info.dart
import 'package:flutter/material.dart';
// DATABASE
import '../database/database_service.dart';
// MODELS
import '../models/horario.dart';
import '../models/cadeira.dart';
import '../models/periodo.dart';

class AulaInformacao extends StatefulWidget {
  final Horario horario;
  const AulaInformacao({super.key, required this.horario});

  @override
  State<AulaInformacao> createState() => _AulaInformacaoState();
}

class _AulaInformacaoState extends State<AulaInformacao> {
  final DataBaseService _dbService = DataBaseService();
  late Future<Cadeira> _cadeiraFuture;
  late Future<Periodo> _periodoFuture;

  @override
  void initState() {
    super.initState();
    // Carrega a cadeira relacionada ao horário
    _cadeiraFuture = _dbService.obterCadeiraPorId(widget.horario.cadeiraID);
    // Carrega o período relacionado ao horário
    _periodoFuture = _dbService.obterPeriodoPorId(widget.horario.periodoID);
  }

  @override
  Widget build(BuildContext context) {
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Informações da Aula'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //CADEIRA
            FutureBuilder<Cadeira>(
              future: _cadeiraFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Erro ao carregar cadeira: ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  return const Text('Cadeira não encontrada');
                }

                final cadeira = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${cadeira.sigla} - ${cadeira.nome}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Informação: ${cadeira.informacao}",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                );
              },
            ),
            Text(
              "Aula do dia ${widget.horario.data}",
              style: TextStyle(fontSize: 18),
            ),
            //PERÍODO
            FutureBuilder<Periodo>(
              future: _periodoFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Erro ao carregar período: ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  return const Text('Período não encontrado');
                }

                final periodo = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hora: ${periodo.horaInicio} - ${periodo.horaFim}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              },
            ),
            Text(
              "Sala: ${widget.horario.sala}",
              style: TextStyle(fontSize: 18),
            ),
            
            const SizedBox(height: 16),
            
          ],
        ),
      ),
    );
  }
}
