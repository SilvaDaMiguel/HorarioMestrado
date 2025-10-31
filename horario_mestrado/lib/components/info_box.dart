import 'package:flutter/material.dart';
// Cores
import '../variables/colors.dart';
import '../variables/size.dart';

class InfoBox extends StatelessWidget {
  final String informacao;

  const InfoBox({Key? key, required this.informacao}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //RESPONSIVIDADE
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    //double altura = tamanho.height;

    return Container(
      width: double.infinity, //Ocupar o máximo possível da largura
      padding: EdgeInsets.all(comprimento * paddingComprimento), //INTERIOR
      decoration: BoxDecoration(
        color: corTerciaria.withValues(alpha: 0.5),
        border: Border.all(color: corSecundaria, width: comprimento / 50),
        borderRadius: BorderRadius.circular(comprimento * arredondamento),
      ),
      child: Text(
        informacao,
        style: TextStyle(
          fontSize: comprimento * tamanhoTexto,
          color: corTexto,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
