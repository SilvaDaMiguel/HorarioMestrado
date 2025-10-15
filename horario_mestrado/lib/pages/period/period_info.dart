import 'package:flutter/material.dart';
//DATABASE
import '../../database/database_service.dart';
//MODELS
import '../../models/periodo.dart';
//VARIABLES
import '../../variables/colors.dart';
import '../../variables/icons.dart';
import '../../variables/size.dart';
//COMPONENTS
import '../../components/structure/navigation_bar.dart';
import '../../components/structure/app_bar.dart';

class PeriodoInformacao extends StatefulWidget {
  final int periodoID;
  const PeriodoInformacao({super.key, required this.periodoID});

  @override
  _PeriodoInformacaoState createState() => _PeriodoInformacaoState();
}

class _PeriodoInformacaoState extends State<PeriodoInformacao> {
  final DataBaseService _dbService = DataBaseService();
  late Future<Periodo> _periodoFuture;

  @override
  void initState() {
    super.initState();
    _periodoFuture = _dbService.obterPeriodoPorId(widget.periodoID);
  }

  @override
  Widget build(BuildContext context) {
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    double altura = tamanho.height;

    //ESPAÇAMENTO
    double espacoTextoTitulo = altura * 0.01;
    double espacoTemas = altura * 0.035;

    //PADDING
    double paddingAltura = altura * 0.075;
    double paddingComprimento = comprimento * 0.06;

    return Scaffold(
      appBar: MinhaAppBar(
        nome: 'Informação do Período',
        icon: iconEditar,
        rota: '/error'
      ), //TODO: Ver como passo o Objeto OU se passo o ID e faço a pesquisa
      body: FutureBuilder<Periodo>(
        future: _periodoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar dados do periodo.'),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text('Periodo não encontrado.'),
            );
          }

          Periodo periodo = snapshot.data!;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: paddingAltura,
              horizontal: paddingComprimento,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //DIA
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        periodo.diaSemana,
                        style: TextStyle(
                          fontSize: comprimento * tamanhoTitulo,
                          fontWeight: FontWeight.bold,
                          color: corTexto,
                        ),
                      ),
                    ),
                    /*
                    IconButton(
                      icon: Icon(Icons.edit,
                          color: corTerciaria, size: tamanhoIcon),
                      onPressed: () async {
                        final result = await Navigator.pushNamed(
                          context,
                          '/subjectEdit',
                          arguments: cadeira,
                        );
                        if (result != null) {
                          setState(() {
                            _cadeiraFuture = Future.value(result as Cadeira);
                          });
                        }
                      },
                    )*/
                  ],
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar:
          MyNavigationBar(mostrarSelecionado: false, IconSelecionado: 1),
    );
  }
}
