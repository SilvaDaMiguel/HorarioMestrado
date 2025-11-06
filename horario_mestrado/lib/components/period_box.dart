import 'package:flutter/material.dart';
//MODELS
import '../models/periodo.dart';
//VARIABLES
import '../variables/colors.dart';
import '../variables/icons.dart';
import '../variables/size.dart';

class PeriodoBox extends StatelessWidget {
  final Periodo periodo;
  final VoidCallback? aoPressionar;

  const PeriodoBox({Key? key, required this.periodo, this.aoPressionar}) : super(key: key);

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
                  periodo.diaSemana,
                  style: TextStyle(
                    fontSize: comprimento * tamanhoTexto,
                    fontWeight: FontWeight.bold,
                    color: corTexto,
                  ),
                ),
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
              print('Sem função atribuída!');
              /*
              Navigator.pushNamed(
                context,
                '/periodInfo',
                arguments: periodo.periodoID, //ID do Objeto
              );*/
            },
          ),
        ],
      ),
    );
  }
}
