import 'package:flutter/material.dart';
//VARIABLES
import '../../variables/colors.dart';
import '../../variables/size.dart';
import '../../variables/icons.dart';

class DatePicker extends StatefulWidget {
  final DateTime? diaInicial;
  final Function(DateTime) onDiaSelecionado;

  const DatePicker({Key? key, this.diaInicial, required this.onDiaSelecionado})
    : super(key: key);

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  late DateTime diaSelecionado;

  @override
  void initState() {
    super.initState();
    diaSelecionado = widget.diaInicial ?? DateTime.now();
  }

  Future<void> _mostrarDatePicker(BuildContext context) async {
    final DateTime? novaData = await showDatePicker(
      context: context,
      initialDate: diaSelecionado,
      firstDate: DateTime(2000),
      lastDate: DateTime(3100),
      builder: (context, child) {
        //Forçar tema escuro para edição
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: corSecundaria,
              onPrimary: corTexto,
              surface: corPrimaria,
              onSurface: corTexto,
            ),
            //Força a cor dos botões "Cancelar" / "OK"
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: corTexto, //cor do texto dos botões
              ),
            ),
            //Forçar o texto a ser da cor desejada
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: corTexto),
              bodyLarge: TextStyle(color: corTexto),
              titleMedium: TextStyle(color: corTexto),
            ),
          ),
          child: child!,
        );
      },
    );

    if (novaData != null && novaData != diaSelecionado) {
      setState(() {
        diaSelecionado = novaData;
      });
      widget.onDiaSelecionado(novaData);
    }
  }

  @override
  Widget build(BuildContext context) {
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    double altura = tamanho.height;

    return GestureDetector(
      onTap: () => _mostrarDatePicker(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: comprimento * paddingIconComprimento,
          vertical: altura * paddingIconAltura,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: comprimento * marginComprimento,
          vertical: altura * marginAlura,
        ),
        decoration: BoxDecoration(
          color: corTerciaria.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: corTerciaria, width: 2),
        ),
        child: Icon(
          iconDia,
          color: corTerciaria,
          size: comprimento * tamanhoIcon,
        ),
      ),
    );
  }
}
