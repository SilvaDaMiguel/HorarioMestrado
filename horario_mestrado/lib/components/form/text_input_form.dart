import 'package:flutter/material.dart';
//VARIABLES
import '../../variables/colors.dart';
import '../../variables/size.dart';

class TextInputForm extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obrigatorio;
  final String? hintText;
  final TextInputType keyboardType;
  final int maxLinhas;
  //TODO: testar e editar

  const TextInputForm({
    Key? key,
    required this.controller,
    required this.label,
    this.obrigatorio = false,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.maxLinhas = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLinhas,
      style: TextStyle(
        color: corTexto, //Cor do Texto
        fontSize: comprimento * tamanhoTexto,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: const OutlineInputBorder(),
        // Exemplo de uso das variáveis de estilo
        labelStyle: TextStyle(color: corTexto),
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
