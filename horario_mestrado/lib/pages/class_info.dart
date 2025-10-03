import 'package:flutter/material.dart';
import 'package:horario_mestrado/components/info_box.dart';
//DATABASE
import '../database/database_service.dart';
//MODELS
import '../models/horario.dart';
import '../models/cadeira.dart';
import '../models/periodo.dart';
//VARIABLES
import '../variables/colors.dart';

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
    double altura = tamanho.height;

    //TEXTO
    double tamanhoTexto = comprimento * 0.04;
    double tamanhoTitulo = comprimento * 0.05;
    double tamanhoSubTexto = tamanhoTexto * 0.8;

    //ESPAÇAMENTO
    double espacoTextoTitulo = altura * 0.01;
    double espacoTemas = altura * 0.035;
    //double espacoIconTexto = comprimento * 0.02;

    //PADDING
    double paddingAltura = altura * 0.075;
    double paddingComprimento = comprimento * 0.06;

    //OUTROS
    double tamanhoIcon = comprimento * 0.05;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            vertical: paddingAltura, horizontal: paddingComprimento),
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
                      '${cadeira.sigla} - ${cadeira.nome}',
                      style: TextStyle(
                          fontSize: tamanhoTitulo,
                          fontWeight: FontWeight.bold,
                          color: corTexto),
                    ),
                    SizedBox(height: espacoTemas),
                    Text(
                      'Aula do dia ${widget.horario.data}',
                      style: TextStyle(
                          fontSize: tamanhoTitulo,
                          fontWeight: FontWeight.bold,
                          color: corTexto),
                    ),
                    //PERÍODO
                    FutureBuilder<Periodo>(
                      future: _periodoFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text(
                              'Erro ao carregar período: ${snapshot.error}');
                        } else if (!snapshot.hasData) {
                          return const Text('Período não encontrado');
                        }

                        final periodo = snapshot.data!;
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.timer, size: tamanhoIcon),
                            Text(
                              '${periodo.horaInicio} - ${periodo.horaFim}',
                              style: TextStyle(
                                  fontSize: tamanhoTexto,
                                  fontWeight: FontWeight.bold,
                                  color: corTexto),
                            ),
                          ],
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.room, size: tamanhoIcon),
                        Text(
                          widget.horario.sala,
                          style: TextStyle(fontSize: tamanhoTexto, color: corTexto),
                        ),
                      ],
                    ),
                    SizedBox(height: espacoTemas),
                    Text(
                      "Professores da Cadeira:",
                      style: TextStyle(
                        fontSize: tamanhoTexto,
                        color: corTexto
                      ),
                    ),
                    SizedBox(height: espacoTextoTitulo),
                    ListView.builder(
                      shrinkWrap:
                          true, //Importante para não dar erro dentro do SingleChildScrollView
                      physics:
                          const NeverScrollableScrollPhysics(), //Evita conflito de scroll
                      padding: EdgeInsets.zero, //Remover o padding interno
                      itemCount: cadeira.professores?.length ??
                          0, //Conta o número de professores
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.center, //Garante centralização
                          children: [
                            Icon(Icons.person, size: tamanhoIcon),
                            Text(
                              cadeira.professores![index],
                              style: TextStyle(fontSize: tamanhoSubTexto, color: corTexto),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: espacoTemas),
                    Text(
                      "Informação da Cadeira:",
                      style: TextStyle(
                        fontSize: tamanhoTexto,
                        color: corTexto,
                      ),
                    ),
                    SizedBox(height: espacoTextoTitulo),
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
