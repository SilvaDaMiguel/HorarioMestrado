import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
//MODELS
import '../../models/periodo.dart';
//VARIABLES
import '../../variables/colors.dart';
import '../../variables/size.dart';

class PeriodoDropdown extends StatelessWidget {
  final Periodo? valorSelecionado;
  final bool obrigatorio;
  final ValueChanged<Periodo?> onValueChanged;
  final String? label;
  final List<Periodo> periodos;

  const PeriodoDropdown({
    super.key,
    required this.valorSelecionado,
    required this.onValueChanged,
    required this.periodos,
    this.obrigatorio = false,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    double altura = tamanho.height;

    return DropdownButtonFormField2<Periodo>(
      isExpanded: true,
      value: valorSelecionado,
      decoration: InputDecoration(
        labelText: label ?? 'Período',
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
      items: periodos.map((periodo) {
        return DropdownMenuItem<Periodo>(
          value: periodo,
          child: Text(
            '${periodo.diaSemana}: ${periodo.horaInicio} - ${periodo.horaFim}',
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
