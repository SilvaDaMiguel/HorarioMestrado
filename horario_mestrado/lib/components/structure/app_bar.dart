import 'package:flutter/material.dart';
//VARIABLES
import '../../variables/colors.dart';
import '../../variables/size.dart';

class MinhaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String nome;
  final IconData? icon;
  //final String rota;
  //final dynamic argumento; //Pode ser INT, Objeto, etc
  final VoidCallback? aoPressionar;

  const MinhaAppBar({
    Key? key,
    required this.nome,
    this.icon,
    //this.rota = '/error',
    //this.argumento,
    this.aoPressionar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //RESPONSIVIDADE
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    double altura = tamanho.height * 0.5;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: altura * paddingAltura,
        horizontal: comprimento * paddingComprimento,
      ), //Adicionando padding em todos os lados
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: corSecundaria, //Cor da borda
            width: 2.5, // Largura da borda
          ),
        ),
        color: corPrimaria,
      ),
      child: SafeArea(
        child: Center( //CENTRAR
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                nome,
                style: TextStyle(
                  color: corTexto,
                  fontWeight: FontWeight.bold,
                  fontSize: comprimento * tamanhoTitulo,
                ),
              ),
              Spacer(),
              if (icon != null)
                IconButton(
                  icon: Icon(
                    icon,
                    size: comprimento * tamanhoIconGrande,
                    color: corTexto,
                  ),
                  onPressed: aoPressionar ?? () {
                    print('Sem função atribuida!');
                    //Navigator.pushNamed(context, rota, arguments: argumento);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
