import 'package:flutter/material.dart';
//VARIABLES
import '../../variables/colors.dart';
import '../../variables/size.dart';
import '../../variables/icons.dart';

class CheckboxForm extends StatelessWidget {
  final bool valor;
  final ValueChanged<bool?>? aoMudar; //callback com o novo valor

  const CheckboxForm({Key? key, required this.valor, this.aoMudar})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;

    return /*Checkbox(
      value: valor,
      onChanged: aoMudar,
      activeColor: corTerciaria, //Cor quando selecionada
      checkColor: corTexto, //Cor do certo
      side: const BorderSide(
        //Borda do checkbox
        color: corSecundaria,
        width: 2.5,
      ),
      shape: RoundedRectangleBorder(
        //Forma do checkbox
        borderRadius: BorderRadius.circular(5),
      ),
    );*/
    //TODO: Testar e Adicionar Margin/Padding
    GestureDetector(
      onTap: aoMudar != null ? () => aoMudar!(!valor) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: valor ? corTerciaria : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: valor ? corTerciaria : Colors.grey,
            width: 2,
          ),
        ),
        child: valor
            ? Icon(
                iconSelecionado,
                color: corTexto,
                size: comprimento * tamanhoIcon, //TODO: Teste tamanho icon checkbox
              )
            : null,
      ),
    );
  }
}
