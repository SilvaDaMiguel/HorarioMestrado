import 'package:flutter/material.dart';
//MODELS
import '../models/periodo.dart';
//VARIABLES
import '../variables/colors.dart';
import '../variables/icons.dart';
import '../variables/size.dart';

class PeriodoBox extends StatelessWidget {
  final Periodo periodo;

  const PeriodoBox({Key? key, required this.periodo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    double altura = tamanho.height;

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: comprimento * 0.03, vertical: altura * 0.01),
      padding: EdgeInsets.symmetric(
          horizontal: comprimento * 0.03, vertical: altura * 0.01),
      decoration: BoxDecoration(
        color: corTerciaria.withValues(alpha: 0.5), //withOpacity descontinuado
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
                Text(periodo.diaSemana,
                    style: TextStyle(
                      fontSize: comprimento * tamanhoTexto,
                      fontWeight: FontWeight.bold,
                      color: corTexto,
                    )),
                SizedBox(height: altura * 0.005),
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
                '/periodInfo',
                arguments: periodo.periodoID, //ID do Objeto
              );
            },
          ),
        ],
      ),
    );
  }
}
