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

class PeriodoAdicionar extends StatefulWidget {
  const PeriodoAdicionar({super.key});

  @override
  State<PeriodoAdicionar> createState() => _PeriodoAdicionarState();
}

class _PeriodoAdicionarState extends State<PeriodoAdicionar> {
  final DataBaseService _dbService = DataBaseService();
  final _formKey = GlobalKey<FormState>();


  // Valores para dropdown e timepicker
  // initialize with sensible defaults to avoid LateInitializationError
  late DiaSemana _diaSemanaSelecionado = DiaSemana.segunda;
  late TimeOfDay _horaInicioSelecionada = TimeOfDay.now();
  late TimeOfDay _horaFimSelecionada = TimeOfDay.now();


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
        
        if (context.mounted) {
          //Volta para a página dos períodos
          Navigator.pop(context, periodoAdicionado);

          Future.microtask(() {
            MinhaSnackBar.mostrar(
              Navigator.of(context).context,
              texto: 'Período adicionado com sucesso!',
              botao: 'Ver',
              rota: '/periodInfo',
              argumento: periodoAdicionado.periodoID,
            );
          });
        }
      } catch (e) {
        if (context.mounted) {
          MinhaSnackBar.mostrar(context, texto: 'Erro ao adicionar período: $e');
        }
        //print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tamanho = MediaQuery.of(context).size;
    final comprimento = tamanho.width;
    final altura = tamanho.height;

    return Scaffold(
      appBar: MinhaAppBar(nome: 'Adicionar Período'),
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
                  Text(
                    timeOfDayParaString(_horaInicioSelecionada),
                    style: TextStyle(
                      color: corTexto,
                      fontSize: comprimento * tamanhoTexto,
                    ),
                  ),
                  const Spacer(),
                  TimePicker(
                    onHoraSelecionada: (novaHora) {
                      setState(() {
                        _horaInicioSelecionada = novaHora;
                      });
                    },
                    horaInicial: _horaInicioSelecionada,
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
                  Text(
                    timeOfDayParaString(_horaFimSelecionada),
                    style: TextStyle(
                      color: corTexto,
                      fontSize: comprimento * tamanhoTexto,
                    ),
                  ),
                  const Spacer(),
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
