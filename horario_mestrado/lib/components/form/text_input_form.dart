import 'package:flutter/material.dart';
//VARIABLES
import '../../variables/colors.dart';
import '../../variables/size.dart';

class TextInputForm extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obrigatorio;
  final TextInputType keyboardType;
  final int maxLinhas;
  final int maxCaracteres;

  const TextInputForm({
    Key? key,
    required this.controller,
    required this.label,
    this.obrigatorio = false,
    this.keyboardType = TextInputType.text,
    this.maxLinhas = 1,
    this.maxCaracteres = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLinhas, //Linhas visíveis
      maxLength: maxCaracteres, //Máximo caracteres
      style: TextStyle(
        color: corTexto, //Cor do Texto
        fontSize: comprimento * tamanhoTexto,
      ),
      decoration: InputDecoration(
        alignLabelWithHint: true, //Para a label estar centrada na 1º linha, caso existam várias
        labelText: label,
        border: const OutlineInputBorder(),
        labelStyle: TextStyle(color: corTexto),
        //Contador de caracteres
        counterStyle: TextStyle(
          color: corTexto,
          fontSize: comprimento * tamanhoSubTexto,
        ),
        //Cor borda normal
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: corTexto),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: corSecundaria, width: 2),
        ),
      ),
      validator: (value) {
        if (obrigatorio && (value == null || value.trim().isEmpty)) {
          return 'Campo obrigatório';
        }
        return null;
      },
    );
  }
}
