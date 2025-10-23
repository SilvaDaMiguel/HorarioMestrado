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
import '../../components/form/time_picker.dart';
import '../../components/form/dropdown_diaSemana.dart';
//FUNCTIONS
import '../../functions.dart';

class PeriodoAdicionar extends StatefulWidget {
  const PeriodoAdicionar({super.key});

  @override
  State<PeriodoAdicionar> createState() => _PeriodoAdicionarState();
}

class _PeriodoAdicionarState extends State<PeriodoAdicionar> {
  final DataBaseService _dbService = DataBaseService();
  final _formKey = GlobalKey<FormState>();


  // Valores para dropdown e timepicker
  late DiaSemana _diaSemanaSelecionado;
  late TimeOfDay _horaInicioSelecionada;
  late TimeOfDay _horaFimSelecionada;


  Future<void> _guardarAlteracoes() async {
    if (_formKey.currentState!.validate()) {

      final periodoAdicionado = Periodo(
        periodoID: await _dbService.obterNovoIDPeriodo(),
        diaSemana: _diaSemanaSelecionado.nomeComAcento,
        horaInicio: timeOfDayParaString(_horaInicioSelecionada),
        horaFim: timeOfDayParaString(_horaFimSelecionada),
      );

      try {
        await _dbService.adicionarPeriodo(periodoAdicionado);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Período adicionado com sucesso!')),
        );
        Navigator.pop(context, periodoAdicionado);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao adicionar período: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tamanho = MediaQuery.of(context).size;
    final comprimento = tamanho.width;
    final altura = tamanho.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Período'),
        backgroundColor: corPrimaria,
      ),
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
                  TimePicker(
                    onHoraSelecionada: (novaHora) {
                      setState(() {
                        _horaFimSelecionada = novaHora;
                      });
                    },
                    horaInicial: _horaFimSelecionada,
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
                  IconButton(
                    onPressed: () {
                      // Exemplo: ação extra se quiseres abrir modal manual
                      debugPrint('Selecionar hora');
                    },
                    icon: Icon(iconHora, color: corTexto),
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
