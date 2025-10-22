import 'package:flutter/material.dart';
//VARIABLES
import '../../variables/enums.dart'; // Ajuste o path conforme a localização do enum

class DiaSemanaDropdown extends StatelessWidget {
  final DiaSemana? valorSelecionado;
  final bool obrigatorio;
  final ValueChanged<DiaSemana?> onValueChanged;
  final String? label;

  const DiaSemanaDropdown({
    super.key,
    required this.valorSelecionado,
    required this.onValueChanged,
    this.obrigatorio = false,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<DiaSemana>(
      initialValue: valorSelecionado, //Se for null, nenhum é selecionado
      decoration: InputDecoration(labelText: label ?? 'Dia da Semana'),
      hint: const Text('Selecionar'), //Texto mostrado quando null
      items: DiaSemana.values.map((dia) {
        return DropdownMenuItem<DiaSemana>(
          value: dia,
          child: Text(dia.nomeComAcento),
        );
      }).toList(),
      onChanged: (novoValor) {
        onValueChanged(novoValor);
      },
      validator: obrigatorio
          ? (value) => value == null ? 'Campo obrigatório' : null
          : null,
    );
  }
}
