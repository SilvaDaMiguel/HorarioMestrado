import 'package:flutter/material.dart';
// Cores
import '../variables/colors.dart';

class InfoBox extends StatelessWidget {
  final String informacao;

  const InfoBox({Key? key, required this.informacao}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //RESPONSIVIDADE
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    //double altura = tamanho.height;

    //TAMANHO TEXTO
    double tamanhoTexto = comprimento * 0.035;

    return Container(
      width: double.infinity, //Ocupar o máximo possível da largura
      //margin: EdgeInsets.symmetric(horizontal: comprimento * 0.03, vertical: altura * 0.01),
      padding: EdgeInsets.all(comprimento * 0.03), //INTERIOR
      decoration: BoxDecoration(
        color: corTerciaria.withOpacity(0.5),
        border: Border.all(
          color: corSecundaria,
          width: comprimento / 50,
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
