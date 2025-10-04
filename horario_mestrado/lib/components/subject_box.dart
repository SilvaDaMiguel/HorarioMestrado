import 'package:flutter/material.dart';
//MODELS
import '../models/cadeira.dart';
//DATABASE
import '../database/database_service.dart';
//VARIABLES
import '../variables/colors.dart';

class SubjectBox extends StatelessWidget {
  final Cadeira cadeira;

  const SubjectBox({Key? key, required this.cadeira}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    double altura = tamanho.height;

    final double tamanhoTexto = comprimento * 0.045;
    final double tamanhoData = comprimento * 0.035;

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
                Text('${cadeira.sigla} - ${cadeira.nome}',
                    style: TextStyle(
                      fontSize: tamanhoTexto,
                      fontWeight: FontWeight.bold,
                      color: corTexto,
                    )),
                SizedBox(height: altura * 0.005),
                Text(
                  'Professores: ${cadeira.professores?.length ?? 0}', //Se for Null => 0
                  style: TextStyle(
                    color: corTexto,
                    fontSize: tamanhoTexto,
                  ),
                ),
                Text(
                  '${cadeira.creditos} ECTS',
                  style: TextStyle(
                    color: corTexto,
                    fontSize: tamanhoTexto,
                  ),
                )
              ],
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.info, color: corTerciaria),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/subjectInfo',
                arguments: cadeira, // objeto Cadeira
              );
            },
          ),
        ],
      ),
    );
  }
}
