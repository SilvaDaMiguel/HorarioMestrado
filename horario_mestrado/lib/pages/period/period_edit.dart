//period_edit.dart
import 'package:flutter/material.dart';
import 'package:horario_mestrado/variables/size.dart';
//DATABASE
import '../../database/database_service.dart';
//MODELS
import '../../models/periodo.dart';
//VARIABLES
import '../../variables/colors.dart';
import '../../variables/enums.dart';
import '../../variables/icons.dart';
//COMPONENTS
import '../../components/structure/navigation_bar.dart';
import '../../components/structure/app_bar.dart';
import '../../components/structure/snack_bar.dart';
import '../../components/form/time_picker.dart';
import '../../components/dropdown/dropdown_diaSemana.dart';
//FUNCTIONS
import '../../functions.dart';

class PeriodoEditar extends StatefulWidget {
  final Periodo periodo;

  const PeriodoEditar({super.key, required this.periodo});

  @override
  State<PeriodoEditar> createState() => _PeriodoEditarState();
}

class _PeriodoEditarState extends State<PeriodoEditar> {
  final DataBaseService _dbService = DataBaseService();
  final _formKey = GlobalKey<FormState>();

  // Valores para dropdown e timepicker
  late DiaSemana _diaSemanaSelecionado;
  late TimeOfDay _horaInicioSelecionada;
  late TimeOfDay _horaFimSelecionada;

  @override
  void initState() {
    super.initState();
    final periodoInicial = widget.periodo;

    // Inicializa valores selecionados
    _diaSemanaSelecionado = DiaSemana.values.firstWhere(
      (d) => d.nomeComAcento == periodoInicial.diaSemana,
      orElse: () => DiaSemana.segunda,
    );

    _horaInicioSelecionada =
        stringParaTimeOfDay(periodoInicial.horaInicio) ?? TimeOfDay.now();
    _horaFimSelecionada =
        stringParaTimeOfDay(periodoInicial.horaFim) ?? TimeOfDay.now();
  }

  Future<void> _guardarAlteracoes() async {
    if (_formKey.currentState!.validate()) {
      final periodoAtualizado = Periodo(
        periodoID: widget.periodo.periodoID,
        diaSemana: _diaSemanaSelecionado.nomeComAcento,
        horaInicio: timeOfDayParaString(_horaInicioSelecionada),
        horaFim: timeOfDayParaString(_horaFimSelecionada),
      );

      try {
        await _dbService.atualizarPeriodo(periodoAtualizado);
        MinhaSnackBar.mostrar(
          context,
          texto: 'Período atualizado com sucesso!',
        );
        Navigator.pop(context, periodoAtualizado);
      } catch (e) {
        MinhaSnackBar.mostrar(context, texto: 'Erro ao editar período: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tamanho = MediaQuery.of(context).size;
    final comprimento = tamanho.width;
    final altura = tamanho.height;

    return Scaffold(
      appBar: MinhaAppBar(nome: 'Editar Informações do Período'),
      body: Padding(
        padding: EdgeInsets.all(comprimento * 0.05),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DiaSemanaDropdown(
                valorSelecionado: _diaSemanaSelecionado,
                label: 'Dia da Semana',
                obrigatorio: true,
                onValueChanged: (novoValor) {
                  if (novoValor != null) {
                    setState(() {
                      _diaSemanaSelecionado = novoValor;
                    });
                  }
                },
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Text(
                    'Hora Inicial: ',
                    style: TextStyle(
                      color: corTexto,
                      fontSize: comprimento * tamanhoTexto,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TimePicker(
                    onHoraSelecionada: (novaHora) {
                      setState(() {
                        _horaInicioSelecionada = novaHora;
                      });
                    },
                    horaInicial: _horaInicioSelecionada,
                  ),
                  Text(
                    timeOfDayParaString(_horaInicioSelecionada),
                    style: TextStyle(
                      color: corTexto,
                      fontSize: comprimento * tamanhoTexto,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Text(
                    'Hora Final: ',
                    style: TextStyle(
                      color: corTexto,
                      fontSize: comprimento * tamanhoTexto,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TimePicker(
                    onHoraSelecionada: (novaHora) {
                      setState(() {
                        _horaFimSelecionada = novaHora;
                      });
                    },
                    horaInicial: _horaFimSelecionada,
                  ),
                  Text(
                    timeOfDayParaString(_horaFimSelecionada),
                    style: TextStyle(
                      color: corTexto,
                      fontSize: comprimento * tamanhoTexto,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              SizedBox(height: altura * 0.05),
              ElevatedButton(
                onPressed: _guardarAlteracoes,
                style: ElevatedButton.styleFrom(
                  backgroundColor: corPrimaria,
                  padding: EdgeInsets.symmetric(
                    vertical: altura * 0.02,
                    horizontal: comprimento * 0.2,
                  ),
                ),
                child: const Text(
                  'Guardar Alterações',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MyNavigationBar(mostrarSelecionado: false),
    );
  }
}
