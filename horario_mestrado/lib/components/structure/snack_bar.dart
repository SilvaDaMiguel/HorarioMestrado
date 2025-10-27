import 'package:flutter/material.dart';
//VARIABLES
import '../../variables/colors.dart';
import '../../variables/size.dart';

class MinhaSnackBar {
  static void mostrar(
    BuildContext context, {
    required String texto,
    String? botao,
    String rota = '/error',
    dynamic argumento,
  }) {
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;

    //Fechar snackbar atual (caso exista)
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final snackBar = SnackBar(
      content: Text(
        texto,
        style: TextStyle(
          color: corTexto,
          fontSize: comprimento * tamanhoTexto,
        ),
      ),
      backgroundColor: corSecundaria,
      behavior: SnackBarBehavior.floating, //flutua acima do conteúdo
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      action: botao != null
          ? SnackBarAction(
              label: botao,
              textColor: corTexto,
              onPressed: () {
                Navigator.pushNamed(context, rota, arguments: argumento);
              },
            )
          : null,
      duration: const Duration(seconds: 5),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
