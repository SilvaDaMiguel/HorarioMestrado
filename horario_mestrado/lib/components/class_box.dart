import 'package:flutter/material.dart';
//MODELS
import '../models/horario.dart';
import '../models/cadeira.dart';
import '../models/periodo.dart';
//DATABASE
import '../database/database_service.dart';
//VARIABLES
import '../variables/colors.dart';
import '../variables/icons.dart';

class ClassBox extends StatefulWidget {
  final Horario horario;

  const ClassBox({Key? key, required this.horario}) : super(key: key);

  @override
  State<ClassBox> createState() => _ClassBoxState();
}

class _ClassBoxState extends State<ClassBox> {
  Horario get horario => widget.horario;

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

  //Atualiza a Pesquisa => Não atualizava o nome da cadeira
  @override
  void didUpdateWidget(covariant ClassBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.horario.cadeiraID != widget.horario.cadeiraID) {
      _cadeiraFuture = _dbService.obterCadeiraPorId(widget.horario.cadeiraID);
    }
    if (oldWidget.horario.periodoID != widget.horario.periodoID) {
      _periodoFuture = _dbService.obterPeriodoPorId(widget.horario.periodoID);
    }
  }

  @override
  Widget build(BuildContext context) {
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    double altura = tamanho.height;

    final double tamanhoTexto = comprimento * 0.045;
    final double tamanhoHora = comprimento * 0.035;

    return FutureBuilder(
      //Espera pelos dois Futures usando Future.wait
      future: Future.wait([_cadeiraFuture, _periodoFuture]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Mostra algo enquanto os dados estão a carregar
          return Container(
            padding: EdgeInsets.all(16),
            child: const CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          // Caso haja erro ao carregar
          return Container(
            padding: EdgeInsets.all(16),
            child: Text('Erro ao carregar a aula',
                style: TextStyle(color: Colors.red)),
          );
        } else {
          // Dados carregados com sucesso
          final Cadeira cadeira = snapshot.data![0] as Cadeira;
          final Periodo periodo = snapshot.data![1] as Periodo;

          return Container(
            margin: EdgeInsets.symmetric(
                horizontal: comprimento * 0.03, vertical: altura * 0.01),
            padding: EdgeInsets.symmetric(
                horizontal: comprimento * 0.03, vertical: altura * 0.01),
            decoration: BoxDecoration(
              color: corTerciaria.withOpacity(0.5),
              border: Border.all(
                color: corSecundaria,
                width: comprimento / 50,
              ),
              borderRadius: BorderRadius.circular(comprimento * 0.05),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cadeira.sigla,
                          style: TextStyle(
                            fontSize: tamanhoTexto,
                            fontWeight: FontWeight.bold,
                            color: corTexto,
                          )),
                      SizedBox(height: altura * 0.005),
                      Text(
                        '${periodo.horaInicio} - ${periodo.horaFim}',
                        style: TextStyle(
                          fontSize: tamanhoHora,
                          color: corTexto,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                /*
                IconButton(
                  icon: Icon(iconInformacao, color: corTerciaria),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/classInfo',
                      arguments: horario, // objeto Horario
                    );
                  },
                ),
                */
                Text(
                  horario.sala,
                  style: TextStyle(
                    fontSize: tamanhoTexto,
                    color: corTexto,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
