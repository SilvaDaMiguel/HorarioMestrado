import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
//VARIABLES
import '../../variables/enums.dart';
import '../../variables/colors.dart';
import '../../variables/size.dart';

class EpocaDropdown extends StatelessWidget {
  final Epoca? valorSelecionado;
  final bool obrigatorio;
  final ValueChanged<Epoca?> onValueChanged;
  final String? label;

  const EpocaDropdown({
    super.key,
    required this.valorSelecionado,
    required this.onValueChanged,
    this.obrigatorio = false,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    double altura = tamanho.height;

    return DropdownButtonFormField2<Epoca>(
      isExpanded: true,
      value: valorSelecionado,
      decoration: InputDecoration(
        labelText: label ?? 'Dia da Semana',
        labelStyle: TextStyle(
          color: corTexto, //Cor do label
          fontSize: comprimento * tamanhoTexto,
          fontWeight: FontWeight.bold,
        ),
        border: const OutlineInputBorder(),
        //cor da borda normal
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: corTexto),
        ),
        //cor da borda selecionada
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: corSecundaria, width: 2),
        ),
      ),
      hint: Text(
        'Selecionar',
        style: TextStyle(
          color: corTexto.withValues(alpha: 0.6), //Cor do texto do hint
          fontSize: comprimento * tamanhoTexto,
        ),
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 250,
        decoration: BoxDecoration(
          color: corPrimaria, //Cor de fundo do menu
          borderRadius: BorderRadius.circular(12),
        ),
        offset: const Offset(0, 4), //Afasta ligeiramente o menu do campo
        elevation: 4,
      ),
      menuItemStyleData: MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: comprimento * paddingComprimento, vertical: altura * paddingAltura),
      ),
      items: Epoca.values.map((epoca) {
        return DropdownMenuItem<Epoca>(
          value: epoca,
          child: Text(
            epoca.nomeEpoca,
            style: TextStyle(
              color: corTexto, //Cor do texto das opções
              fontSize: comprimento * tamanhoTexto,
            ),
          ),
        );
      }).toList(),
      onChanged: (novoValor) => onValueChanged(novoValor),
      validator: obrigatorio
          ? (value) => value == null ? 'Campo obrigatório' : null
          : null,
    );
  }
}
