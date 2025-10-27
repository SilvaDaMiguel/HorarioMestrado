import 'package:flutter/material.dart';
//MODELS
import '../models/cadeira.dart';
//VARIABLES
import '../variables/colors.dart';
import '../variables/icons.dart';
import '../variables/size.dart';

class CadeiraBox extends StatelessWidget {
  final Cadeira cadeira;

  const CadeiraBox({Key? key, required this.cadeira}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    double altura = tamanho.height;

    return Container(
      margin: EdgeInsets.symmetric(vertical: altura * marginAlura),
      padding: EdgeInsets.symmetric(
        horizontal: comprimento * paddingComprimento,
        vertical: altura * paddingAltura,
      ),
      decoration: BoxDecoration(
        color: corTerciaria.withValues(alpha: 0.5), //withOpacity descontinuado
        border: Border.all(color: corSecundaria, width: comprimento / 50),
        borderRadius: BorderRadius.circular(comprimento * 0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nome da cadeira
          Text(
            '${cadeira.sigla} - ${cadeira.nome}',
            style: TextStyle(
              fontSize: comprimento * tamanhoTexto,
              fontWeight: FontWeight.bold,
              color: corTexto,
            ),
          ),
          Row(
            children: [
              //Linha com o número de professores e créditos
              Row(
                children: [
                  Icon(iconProfessor, size: comprimento * tamanhoIcon),
                  Text(
                    '${cadeira.professores?.length ?? 0}', // Se for Null => 0
                    style: TextStyle(
                      color: corTexto,
                      fontSize: comprimento * tamanhoTexto,
                    ),
                  ),
                ],
              ),
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
              fontSize: comprimento * tamanhoTexto,
              color: corTexto,
            ),
          ),
        ],
      ),
    );
  }
}
