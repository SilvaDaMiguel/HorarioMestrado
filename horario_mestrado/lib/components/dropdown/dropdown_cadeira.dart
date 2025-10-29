import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
//MODELS
import '../../models/cadeira.dart';
//VARIABLES
import '../../variables/colors.dart';
import '../../variables/size.dart';

class CadeiraDropdown extends StatelessWidget {
  final Cadeira? valorSelecionado;
  final bool obrigatorio;
  final ValueChanged<Cadeira?> onValueChanged;
  final String? label;
  final List<Cadeira> cadeiras;

  const CadeiraDropdown({
    super.key,
    required this.valorSelecionado,
    required this.onValueChanged,
    required this.cadeiras,
    this.obrigatorio = false,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    double altura = tamanho.height;

    return DropdownButtonFormField2<Cadeira>(
      isExpanded: true,
      value: valorSelecionado,
      decoration: InputDecoration(
        labelText: label ?? 'Cadeira',
        labelStyle: TextStyle(
          color: corTexto,
          fontSize: comprimento * tamanhoTexto,
          fontWeight: FontWeight.bold,
        ),
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: corTexto),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: corSecundaria, width: 2),
        ),
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 250,
        decoration: BoxDecoration(
          color: corPrimaria,
          borderRadius: BorderRadius.circular(12),
        ),
        offset: const Offset(0, 0),
        elevation: 4,
      ),
      menuItemStyleData: MenuItemStyleData(
        padding: EdgeInsets.symmetric(
          horizontal: comprimento * paddingComprimento,
          vertical: altura * paddingAltura,
        ),
      ),
      hint: Text(
        'Selecionar',
        style: TextStyle(
          color: corTexto.withValues(alpha: 0.6),
          fontSize: comprimento * tamanhoTexto,
        ),
      ),
      items: cadeiras.map((cadeira) {
        return DropdownMenuItem<Cadeira>(
          value: cadeira,
          child: Text(
            '${cadeira.sigla}: ${cadeira.ano}º - ${cadeira.semestre}ª',
            style: TextStyle(
              color: corTexto,
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
