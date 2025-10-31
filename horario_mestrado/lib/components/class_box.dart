import 'package:flutter/material.dart';
//MODELS
import '../models/aula.dart';
import '../models/cadeira.dart';
import '../models/periodo.dart';
//DATABASE
import '../database/database_service.dart';
//VARIABLES
import '../variables/colors.dart';
import '../variables/icons.dart';
import '../variables/size.dart';

class AulaBox extends StatefulWidget {
  final Aula aula;

  const AulaBox({Key? key, required this.aula}) : super(key: key);

  @override
  State<AulaBox> createState() => _AulaBoxState();
}

class _AulaBoxState extends State<AulaBox> {
  Aula get aula => widget.aula;

  final DataBaseService _dbService = DataBaseService();
  late Future<Cadeira> _cadeiraFuture;
  late Future<Periodo> _periodoFuture;

  @override
  void initState() {
    super.initState();
    //Carrega a cadeira relacionada à aula
    _cadeiraFuture = _dbService.obterCadeiraPorId(widget.aula.cadeiraID);
    // Carrega o período relacionado à aula
    _periodoFuture = _dbService.obterPeriodoPorId(widget.aula.periodoID);
  }

  @override
  Widget build(BuildContext context) {
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    double altura = tamanho.height;

    return FutureBuilder(
      //Espera pelos dois Futures usando Future.wait
      future: Future.wait([_cadeiraFuture, _periodoFuture]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
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
              'Erro ao carregar a aula',
              style: TextStyle(color: Colors.red),
            ),
          );
        } else {
          //Dados carregados com sucesso
          final Cadeira cadeira = snapshot.data![0] as Cadeira;
          final Periodo periodo = snapshot.data![1] as Periodo;

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
                  '${cadeira.sigla} - ${cadeira.nome}',
                  style: TextStyle(
                    fontSize: comprimento * tamanhoTexto,
                    fontWeight: FontWeight.bold,
                    color: corTexto,
                  ),
                ),
                SizedBox(height: altura * 0.005),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${aula.data}, ${periodo.diaSemana}',
                            style: TextStyle(
                              fontSize: comprimento * tamanhoSubTexto,
                              color: corTexto,
                            ),
                          ),
                          Text(
                            '${periodo.horaInicio} - ${periodo.horaFim}',
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
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/classInfo',
                          arguments: aula.aulaID, //ID do Objeto
                        );
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
