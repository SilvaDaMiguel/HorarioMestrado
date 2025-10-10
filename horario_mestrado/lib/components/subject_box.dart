import 'package:flutter/material.dart';
//MODELS
import '../models/cadeira.dart';
//VARIABLES
import '../variables/colors.dart';
import '../variables/icons.dart';

class CadeiraBox extends StatelessWidget {
  final Cadeira cadeira;

  const CadeiraBox({Key? key, required this.cadeira}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    double altura = tamanho.height;

    //TEXTO
    final double tamanhoTexto = comprimento * 0.045;

    //OUTROS
    double tamanhoIcon = comprimento * 0.05;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nome da cadeira
          Text('${cadeira.sigla} - ${cadeira.nome}',
              style: TextStyle(
                fontSize: tamanhoTexto,
                fontWeight: FontWeight.bold,
                color: corTexto,
              )),
          SizedBox(height: altura * 0.005),

          // Linha com o número de professores e créditos
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(iconProfessor, size: tamanhoIcon),
                      Text(
                        '${cadeira.professores?.length ?? 0}', // Se for Null => 0
                        style: TextStyle(
                          color: corTexto,
                          fontSize: tamanhoTexto,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${cadeira.creditos} ECTS',
                    style: TextStyle(
                      color: corTexto,
                      fontSize: tamanhoTexto,
                    ),
                  ),
                ],
              ),

              SizedBox(width: comprimento * 0.05), // Espaço entre as colunas
              //Icon de informações
              Spacer(),
              IconButton(
                icon: Icon(iconInformacao, color: corTerciaria),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/subjectInfo',
                    arguments: cadeira.cadeiraID, //ID da Cadeira
                  );
                },
              ),
            ],
          ),
          Text(
            '${cadeira.ano}º Ano ${cadeira.semestre}º Semestre',
            style: TextStyle(
              fontSize: tamanhoTexto,
              color: corTexto,
            ),
          ),
        ],
      ),
    );
  }
}
