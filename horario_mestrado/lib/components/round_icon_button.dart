import 'package:flutter/material.dart';
//VARIABLES
import '../variables/colors.dart';
import '../variables/size.dart';
import '../variables/icons.dart';

class IconBotaoRedondo extends StatelessWidget {
  final VoidCallback? aoSelecionar;
  final Color corIcon;

  const IconBotaoRedondo({Key? key, this.aoSelecionar, this.corIcon = corTexto})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;

    return Container(
      decoration: BoxDecoration(
        color: corSecundaria,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          iconApagar,
          size: comprimento * tamanhoIconGrande,
          color: corIcon,
        ),
        onPressed:
            aoSelecionar ??
            () {
              print('Sem função atribuída');
            },
      ),
    );
  }
}
