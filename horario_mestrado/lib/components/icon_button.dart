import 'package:flutter/material.dart';
import 'package:horario_mestrado/variables/icons.dart';
//VARIABLES
import '../variables/colors.dart';
import '../variables/size.dart';

class IconBotao extends StatelessWidget {
  final VoidCallback? aoSelecionar;

  const IconBotao({Key? key, this.aoSelecionar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;

    return IconButton(
      icon: Icon(
        iconApagar,
        size: comprimento * tamanhoIconGrande,
        color: corTexto,
      ),
      onPressed: aoSelecionar ?? () {
        print('Sem função atribuída');
      },
    );
  }
}
