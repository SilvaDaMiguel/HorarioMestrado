import 'package:flutter/material.dart';
//VARIABLES
import '../../variables/colors.dart';
import '../../variables/size.dart';

class BotaoSubmeter extends StatelessWidget {
  final VoidCallback? aoPressionar;
  final String texto;

  const BotaoSubmeter({Key? key, this.aoPressionar, required this.texto})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    double altura = tamanho.height;

    return ElevatedButton(
      onPressed:
          aoPressionar ??
          () {
            print('Sem função atríbuida!');
          },
      style: ElevatedButton.styleFrom(
        backgroundColor: corTerciaria.withValues(alpha: 0.5),
        shadowColor: Colors.black.withValues(
          alpha: 0.2,
        ), //Talvez mudar sombra do botão
        elevation: 5, // Sombra
        side: BorderSide(color: corSecundaria, width: comprimento / 50), //Borda
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(comprimento * arredondamento)),
        padding: EdgeInsets.symmetric(
          vertical: altura * paddingAltura,
          horizontal: comprimento * paddingComprimento,
        ),
      ),
      child: Text(
        texto,
        style: TextStyle(color: corTexto, fontSize: comprimento * tamanhoTexto),
      ),
    );
  }
}
