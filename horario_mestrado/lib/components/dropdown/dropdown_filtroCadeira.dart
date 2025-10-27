import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import '../../variables/enums.dart';
import '../../variables/colors.dart';
import '../../variables/size.dart';

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
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    double altura = tamanho.height;

    return DropdownButtonFormField2<FiltroCadeiras>(
      isExpanded: true,
      value: valorSelecionado ?? FiltroCadeiras.ano1semestre1,
      decoration: InputDecoration(
        labelText: label ?? 'Filtro Cadeira',
        labelStyle: TextStyle(
          color: corTexto,
          fontSize: comprimento * tamanhoTexto,
          fontWeight: FontWeight.bold,
        ),
        border: const OutlineInputBorder(),
        //Cor borda normal
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: corTexto),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: corSecundaria, width: 2),
        ),
      ),
      //cor da borda selecionada
      dropdownStyleData: DropdownStyleData(
        maxHeight: 250,
        decoration: BoxDecoration(
          color: corPrimaria, //cor do fundo do menu
          borderRadius: BorderRadius.circular(12),
        ),
        offset: const Offset(0, 0), //move o menu (positivo = abaixo)
        elevation: 4,
      ),
      menuItemStyleData: MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: comprimento * paddingComprimento, vertical: altura * paddingAltura),
      ),
      items: FiltroCadeiras.values.map((filtro) {
        return DropdownMenuItem<FiltroCadeiras>(
          value: filtro,
          child: Text(
            filtro.nomeFiltro,
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
