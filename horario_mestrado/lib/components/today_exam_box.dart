import 'package:flutter/material.dart';
//MODELS
import '../models/prova.dart';
import '../models/cadeira.dart';
//DATABASE
import '../database/database_service.dart';
//VARIABLES
import '../variables/colors.dart';
import '../variables/size.dart';

class ProvaCalendarioBox extends StatefulWidget {
  final Prova prova;

  const ProvaCalendarioBox({Key? key, required this.prova}) : super(key: key);

  @override
  State<ProvaCalendarioBox> createState() => _ProvaCalendarioBoxState();
}

class _ProvaCalendarioBoxState extends State<ProvaCalendarioBox> {
  Prova get prova => widget.prova;

  final DataBaseService _dbService = DataBaseService();
  late Future<Cadeira> _cadeiraFuture;

  @override
  void initState() {
    super.initState();
    // Carrega a cadeira relacionada à prova
    _cadeiraFuture = _dbService.obterCadeiraPorId(widget.prova.cadeiraID);
  }

  //Atualiza a Pesquisa => Não atualizava o nome da cadeira
  @override
  void didUpdateWidget(covariant ProvaCalendarioBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.prova.cadeiraID != widget.prova.cadeiraID) {
      _cadeiraFuture = _dbService.obterCadeiraPorId(widget.prova.cadeiraID);
    }
  }

  @override
  Widget build(BuildContext context) {
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    double altura = tamanho.height;

    return FutureBuilder<Cadeira>(
      //Espera pelos dois Futures usando Future.wait
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
          // Dados carregados com sucesso
          final Cadeira cadeira = snapshot.data as Cadeira;

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${prova.tipo} ${cadeira.sigla}',
                        style: TextStyle(
                          fontSize: comprimento * tamanhoTitulo,
                          fontWeight: FontWeight.bold,
                          color: corTexto,
                        ),
                      ),
                      SizedBox(height: altura * distanciaItensBox),
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
                Text(
                  prova.sala,
                  style: TextStyle(
                    fontSize: comprimento * tamanhoTitulo,
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
