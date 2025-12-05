import 'package:flutter/material.dart';
import 'package:horario_mestrado/functions.dart';
import 'package:horario_mestrado/variables/enums.dart';
//MODELS
import '../models/prova.dart';
import '../models/cadeira.dart';
//DATABASE
import '../database/database_service.dart';
//VARIABLES
import '../variables/colors.dart';
import '../variables/icons.dart';
import '../variables/size.dart';
//FUNCTIONS

class ProvaBox extends StatefulWidget {
  final Prova prova;
  final VoidCallback? aoPressionar;

  const ProvaBox({Key? key, required this.prova, this.aoPressionar}) : super(key: key);

  @override
  State<ProvaBox> createState() => _ProvaBoxState();
}

class _ProvaBoxState extends State<ProvaBox> {
  Prova get prova => widget.prova;
  VoidCallback? get aoPressionar => widget.aoPressionar;

  final DataBaseService _dbService = DataBaseService();
  late Future<Cadeira> _cadeiraFuture;

  @override
  void initState() {
    super.initState();
    //Carrega a cadeira relacionada à prova
    _cadeiraFuture = _dbService.obterCadeiraPorId(widget.prova.cadeiraID);
  }

  @override
  Widget build(BuildContext context) {
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    double altura = tamanho.height;

    return FutureBuilder<Cadeira>(
      //Espera apenas pelo Future da cadeira
      future: _cadeiraFuture,
      builder: (context, AsyncSnapshot<Cadeira> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          //Mostra algo enquanto os dados estão a carregar
          return Container(
            padding: EdgeInsets.all(16),
            child: const CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          // Caso haja erro ao carregar
          return Container(
            padding: EdgeInsets.all(16),
            child: Text(
              'Erro ao carregar a prova',
              style: TextStyle(color: Colors.red),
            ),
          );
        } else {
          //Dados carregados com sucesso
          final Cadeira cadeira = snapshot.data!;

          return Container(
            margin: EdgeInsets.symmetric(vertical: altura * marginAlura),
            padding: EdgeInsets.symmetric(
              horizontal: comprimento * paddingComprimento,
              vertical: altura * paddingAltura,
            ),
            decoration: BoxDecoration(
              color: corTerciaria.withValues(alpha: 0.5),
              border: Border.all(color: corSecundaria, width: comprimento / 50),
              borderRadius: BorderRadius.circular(comprimento * arredondamento),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${prova.tipo} ${cadeira.sigla} - ${cadeira.nome}',
                  style: TextStyle(
                    fontSize: comprimento * tamanhoTexto,
                    fontWeight: FontWeight.bold,
                    color: corTexto,
                  ),
                ),
                SizedBox(height: altura * distanciaItensBox),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${prova.data}, ${obterDiaSemana(stringDDMMYYYYParaDateTime(prova.data)!).nomeComAcento}',
                            style: TextStyle(
                              fontSize: comprimento * tamanhoSubTexto,
                              color: corTexto,
                            ),
                          ),
                          Text(
                            '${prova.horaInicio} - ${prova.horaFim}',
                            style: TextStyle(
                              fontSize: comprimento * tamanhoSubTexto,
                              color: corTexto,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(iconInformacao, color: corTerciaria),
                      onPressed: aoPressionar ?? () {
                        print('Sem função atribuída');
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
