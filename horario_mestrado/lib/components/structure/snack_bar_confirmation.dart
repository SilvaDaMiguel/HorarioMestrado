import 'package:flutter/material.dart';
//VARIABLES
import '../../variables/colors.dart';
import '../../variables/size.dart';

class MinhaSnackBarConfirmacao {
  static Future<bool?> mostrar(
    BuildContext context, {
    required String texto,
  }) async {
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;

    //Fechar snackbar atual (caso exista)
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // Completer para capturar a resposta do usuário
    bool? resposta;

    final snackBar = SnackBar(
      content: Text(
        texto,
        style: TextStyle(
          color: corTexto,
          fontSize: comprimento * tamanhoTexto,
        ),
      ),
      backgroundColor: corSecundaria,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      action: SnackBarAction(
        label: 'Sim',
        textColor: corTexto,
        onPressed: () {
          resposta = true;
        },
      ),
      duration: const Duration(seconds: 5),
    );

    //Mostrar a SnackBar e aguardar o resultado
    final snackBarController = ScaffoldMessenger.of(context).showSnackBar(snackBar);
    
    //Aguardar até que a SnackBar seja fechada
    await snackBarController.closed;
    
    //Se resposta ainda for null, significa que o utilizador não confirmou
    return resposta ?? false;
  }
}