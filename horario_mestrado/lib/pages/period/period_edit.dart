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
import '../../components/form/time_picker.dart';
import '../../components/form/dropdown_diaSemana.dart';
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

  late String _diaSemana;
  late TimeOfDay _horaInicio;
  late String _horaFim;

  @override
  void initState() {
    super.initState();
    //Preenche os campos com os valores iniciais
    final periodoInicial = widget.periodo;
    _diaSemana = periodoInicial.diaSemana;
    _horaInicio =
        stringParaTimeOfDay(periodoInicial.horaInicio) ?? TimeOfDay.now();
    _horaFim = periodoInicial.horaFim;
  }

  Future<void> _guardarAlteracoes() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final periodoAtualizado = Periodo(
        periodoID: widget.periodo.periodoID,
        diaSemana: _diaSemana,
        horaInicio: timeOfDayParaString(
          _horaInicio,
        ), //Converte o TImeOfDay para String (HH:mm)
        horaFim: _horaFim,
      );

      try {
        await _dbService.atualizarPeriodo(periodoAtualizado);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Periodo atualizado com sucesso!')),
        );
        Navigator.pop(context, periodoAtualizado);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar periodo: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    double altura = tamanho.height;
    //TODO: Criar os componentes personalizados

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Cadeira'),
        backgroundColor: corPrimaria,
      ),
      body: Padding(
        padding: EdgeInsets.all(comprimento * 0.05),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DiaSemanaDropdown(
                valorSelecionado: DiaSemana.values.firstWhere(
                  (d) => d.nomeComAcento == _diaSemana,
                  orElse: () =>
                      DiaSemana.segunda, //valor default se não encontrar
                ),
                label: 'Dia da Semana',
                obrigatorio: true, //É obrigatório
                onValueChanged: (novoValor) {
                  if (novoValor != null) {
                    setState(() {
                      _diaSemana = novoValor.nomeComAcento;
                    });
                  }
                },
              ),
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
                  //TODO: Teste TimePicker
                  TimePicker(
                    onHoraSelecionada: (novaHora) {
                      setState(() {
                        _horaInicio = novaHora;
                      });
                    },
                    horaInicial: _horaInicio,
                  ),
                  Text(
                    timeOfDayParaString(_horaInicio),
                    style: TextStyle(
                      color: corTexto,
                      fontSize: comprimento * tamanhoTexto,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      //TODO: Escolher Hora
                      print('Selecionar hora');
                    },
                    icon: Icon(iconHora, color: corTexto),
                  ),
                ],
              ),
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
