import 'package:flutter/material.dart';
//DATABASE
import '../../database/database_service.dart';
//MODELS
import '../../models/aula.dart';
import '../../models/cadeira.dart';
import '../../models/periodo.dart';
//VARIABLES
import '../../variables/colors.dart';
//Components
import '../../components/info_box.dart';

class AulaInformacao extends StatefulWidget {
  final Aula aula;
  const AulaInformacao({super.key, required this.aula});

  @override
  State<AulaInformacao> createState() => _AulaInformacaoState();
}

class _AulaInformacaoState extends State<AulaInformacao> {
  final DataBaseService _dbService = DataBaseService();
  late Future<List<dynamic>> _dadosFuture;

  @override
  void initState() {
    super.initState();
    _dadosFuture = Future.wait([
      _dbService.obterCadeiraPorId(widget.aula.cadeiraID),
      _dbService.obterPeriodoPorId(widget.aula.periodoID),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    double altura = tamanho.height;

    //TEXTO
    double tamanhoTexto = comprimento * 0.04;
    double tamanhoTitulo = comprimento * 0.05;
    double tamanhoSubTexto = tamanhoTexto * 0.8;

    //ESPAÇAMENTO
    double espacoTextoTitulo = altura * 0.01;
    double espacoTemas = altura * 0.035;

    //PADDING
    double paddingAltura = altura * 0.075;
    double paddingComprimento = comprimento * 0.06;

    //OUTROS
    double tamanhoIcon = comprimento * 0.05;

    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: _dadosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Dados não encontrados'));
          }

          final cadeira = snapshot.data![0] as Cadeira;
          final periodo = snapshot.data![1] as Periodo;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: paddingAltura,
              horizontal: paddingComprimento,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${cadeira.sigla} - ${cadeira.nome}',
                  style: TextStyle(
                    fontSize: tamanhoTitulo,
                    fontWeight: FontWeight.bold,
                    color: corTexto,
                  ),
                ),
                SizedBox(height: espacoTemas),
                Text(
                  'Aula do dia ${widget.aula.data}',
                  style: TextStyle(
                    fontSize: tamanhoTitulo,
                    fontWeight: FontWeight.bold,
                    color: corTexto,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.timer, size: tamanhoIcon),
                    Text(
                      '${periodo.horaInicio} - ${periodo.horaFim}',
                      style: TextStyle(
                        fontSize: tamanhoTexto,
                        fontWeight: FontWeight.bold,
                        color: corTexto,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.room, size: tamanhoIcon),
                    Text(
                      widget.aula.sala,
                      style: TextStyle(fontSize: tamanhoTexto, color: corTexto),
                    ),
                  ],
                ),
                SizedBox(height: espacoTemas),
                Text(
                  "Professores da Cadeira:",
                  style: TextStyle(fontSize: tamanhoTexto, color: corTexto),
                ),
                SizedBox(height: espacoTextoTitulo),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: cadeira.professores?.length ?? 0,
                  itemBuilder: (context, index) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.person, size: tamanhoIcon),
                        Text(
                          cadeira.professores![index],
                          style: TextStyle(
                              fontSize: tamanhoSubTexto, color: corTexto),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: espacoTemas),
                Text(
                  "Informação da Cadeira:",
                  style: TextStyle(fontSize: tamanhoTexto, color: corTexto),
                ),
                SizedBox(height: espacoTextoTitulo),
                InfoBox(informacao: cadeira.informacao),
              ],
            ),
          );
        },
      ),
    );
  }
}
