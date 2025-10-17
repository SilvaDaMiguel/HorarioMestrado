import 'package:flutter/material.dart';
//VARIABLES
import '../../variables/colors.dart';
import '../../variables/size.dart';

class TimePicker extends StatefulWidget {
  final TimeOfDay? horaInicial;
  final Function(TimeOfDay) onHoraSelecionada;

  const TimePicker({
    Key? key,
    this.horaInicial,
    required this.onHoraSelecionada,
  }) : super(key: key);

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  late TimeOfDay horaSelecionada;

  @override
  void initState() {
    super.initState();
    horaSelecionada = widget.horaInicial ?? TimeOfDay.now();
  }

  Future<void> _mostrarTimePicker(BuildContext context) async {
    final TimeOfDay? novaHora = await showTimePicker(
      context: context,
      initialTime: horaSelecionada,
      builder: (context, child) {
        // Personalização opcional para tema dark
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (novaHora != null && novaHora != horaSelecionada) {
      setState(() {
        horaSelecionada = novaHora;
      });
      widget.onHoraSelecionada(novaHora);
    }
  }

  //TODO: Testar TimePicker
  @override
  Widget build(BuildContext context) {
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;

    return GestureDetector(
      onTap: () => _mostrarTimePicker(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: corTerciaria.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: corTerciaria, width: 2),
        ),
        child: Icon(
          Icons.access_time,
          color: corTerciaria,
          size: comprimento * tamanhoIconPequeno,
        ),
      ),
    );
  }
}
