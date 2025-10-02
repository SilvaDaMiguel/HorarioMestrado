import 'package:flutter/material.dart';
import 'package:horario_mestrado/components/info_box.dart';
//DATABASE
import '../database/database_service.dart';
//MODELS
import '../models/horario.dart';
import '../models/cadeira.dart';
import '../models/periodo.dart';
//COMPONENTS

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

    //TEXTO
    double tamanhoTexto = comprimento * 0.035;
    double tamanhoTitulo = comprimento * 0.05;
    double tamanhoSubTexto = tamanhoTexto * 0.5;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Aula do dia ${widget.horario.data}',
          style: TextStyle(
            fontSize: tamanhoTitulo,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.timer),
                    Text(
                      '${periodo.horaInicio} - ${periodo.horaFim}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.room),
                Text(
                  widget.horario.sala,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
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
                      '${cadeira.sigla} - ${cadeira.nome}',
                      style: TextStyle(
                          fontSize: tamanhoTitulo, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Informação da Cadeira:",
                      style: TextStyle(
                        fontSize: tamanhoTexto,
                      ),
                    ),
                    InfoBox(informacao: cadeira.informacao),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
