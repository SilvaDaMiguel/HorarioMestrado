import 'package:flutter/material.dart';
//VARIABLES
import '../variables/colors.dart';
import '../variables/icons.dart';

class AdicionarAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String nome;
  final String rota;

  const AdicionarAppBar({Key? key, required this.nome, this.rota = '/error'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //RESPONSIVIDADE
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width * 0.06;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black, // Cor da borda
            width: 2.5, // Largura da borda
          ),
        ),
        color: corPrimaria,
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(nome,
                style: TextStyle(
                  color: corTexto,
                  fontWeight: FontWeight.bold,
                  fontSize: comprimento,
                )),
            Spacer(),
            IconButton(
              icon: Icon(
                iconAdicionar,
                size: comprimento,
                color: corTexto,
              ),
              onPressed: () {
                Navigator.pushNamed(context, rota);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
