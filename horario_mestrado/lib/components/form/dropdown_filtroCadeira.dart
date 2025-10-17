import 'package:flutter/material.dart';
//VARIABLES
import '../../variables/enums.dart'; // Ajuste o path conforme a localização do enum

class FiltroCadeiraDropdown extends StatelessWidget {
  final FiltroCadeiras? valorSelecionado;
  final bool obrigatorio;
  final ValueChanged<FiltroCadeiras?> onValueChanged;
  final String? label;

  const FiltroCadeiraDropdown({
    super.key,
    required this.valorSelecionado,
    required this.onValueChanged,
    this.obrigatorio = false,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<FiltroCadeiras>(
      initialValue:
          valorSelecionado ??
          FiltroCadeiras.ano1semestre1, //Valor default caso venha null
      decoration: InputDecoration(labelText: label ?? 'Filtro Cadeira'),
      items: FiltroCadeiras.values.map((filtro) {
        return DropdownMenuItem<FiltroCadeiras>(
          value: filtro,
          child: Text(filtro.nomeFiltro),
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
