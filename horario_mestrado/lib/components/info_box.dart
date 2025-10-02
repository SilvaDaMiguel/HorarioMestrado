import 'package:flutter/material.dart';
//Cores
import '../variables/colors.dart';

class InfoBox extends StatelessWidget {
  final String informacao;

  const InfoBox({Key? key, required this.informacao}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //RESPONSIVIDADE
    var tamanho = MediaQuery.of(context).size;
    double largura = tamanho.width;
    double altura = tamanho.height;

    final Color corFundo = Colors.grey[200]!;
    final Color corBorda = Colors.blue;
    final double tamanhoTexto = largura * 0.035;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: largura * 0.03, vertical: altura * 0.01),
      padding: EdgeInsets.all(largura * 0.03),
      decoration: BoxDecoration(
        color: corFundo,
        border: Border.all(
          color: corBorda,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        informacao,
        style: TextStyle(
          fontSize: tamanhoTexto,
          color: corTexto,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
