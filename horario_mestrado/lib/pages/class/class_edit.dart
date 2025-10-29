import 'package:flutter/material.dart';
// DATABASE
import '../../database/database_service.dart';
// MODELS
import '../../models/periodo.dart';
import '../../models/aula.dart';
import '../../models/cadeira.dart';
// VARIABLES
import '../../variables/colors.dart';
import '../../variables/size.dart';
import '../../variables/enums.dart';
// COMPONENTS
import '../../components/structure/navigation_bar.dart';
import '../../components/structure/app_bar.dart';
import '../../components/structure/snack_bar.dart';
import '../../components/form/text_input_form.dart';
import '../../components/dropdown/dropdown_periodo.dart';
import '../../components/dropdown/dropdown_cadeira.dart';
import '../../components/form/date_picker.dart';
//FUNCTIONS
import '../../functions.dart';

class AulaEditar extends StatefulWidget {
  final Aula aula;
  const AulaEditar({super.key, required this.aula});

  @override
  State<AulaEditar> createState() => _AulaEditarState();
}

class _AulaEditarState extends State<AulaEditar> {
  final DataBaseService _dbService = DataBaseService();
  final _formKey = GlobalKey<FormState>();

  // Controladores
  late TextEditingController _salaController;

  // Outros inputs
  late DateTime _diaSelecionado;

  Periodo? _periodoSelecionado;
  List<Periodo> _periodosDisponiveis = [];
  Cadeira? _cadeiraSelecionada;
  List<Cadeira> _cadeirasDisponiveis = [];

  DiaSemana? diaSemana;

  @override
  void initState() {
    super.initState();
    _salaController = TextEditingController(text: widget.aula.sala);
    _diaSelecionado = stringDDMMYYYYParaDateTime(widget.aula.data)!;
    _inicializarDados();
  }

  Future<void> _inicializarDados() async {
    //Carregar periodo e cadeira da aula inicial
    _periodoSelecionado = await _dbService.obterPeriodoPorId(
      widget.aula.periodoID,
    );
    _cadeiraSelecionada = await _dbService.obterCadeiraPorId(
      widget.aula.cadeiraID,
    );

    //Obter o dia da semana e carregar opções
    _obterDiaSemana();
  }

  Future<void> _carregarPeriodos() async {
    if (diaSemana == null) return;
    final periodos = await _dbService.obterPeriodosFiltradosDiaSemana(
      diaSemana!.nomeComAcento,
    );
    setState(() {
      _periodosDisponiveis = periodos;
    });
  }

  Future<void> _carregarCadeiras() async {
    final cadeiras = await _dbService.obterCadeiras();
    setState(() {
      _cadeirasDisponiveis = cadeiras;
    });
  }

  void _obterDiaSemana() {
    setState(() {
      diaSemana = obterDiaSemana(_diaSelecionado);
    });
    _carregarPeriodos();
    _carregarCadeiras();
  }

  @override
  void dispose() {
    _salaController.dispose();
    super.dispose();
  }

  Future<void> _guardarAlteracoes() async {
    if (!_formKey.currentState!.validate()) return;

    final aulaAtualizada = Aula(
      aulaID: widget.aula.aulaID,
      cadeiraID: _cadeiraSelecionada!.cadeiraID, //Não será Null
      periodoID: _periodoSelecionado!.periodoID, //Não será Null
      data: formatarDataDDMMYYYY(_diaSelecionado),
      sala: _salaController.text.trim(),
    );

    try {
      await _dbService.atualizarAula(aulaAtualizada);
      MinhaSnackBar.mostrar(context, texto: 'Aula atualizada com sucesso!');
      Navigator.pop(context, aulaAtualizada);
    } catch (e) {
      MinhaSnackBar.mostrar(context, texto: 'Erro ao editar aula: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    double altura = tamanho.height;

    return Scaffold(
      appBar: const MinhaAppBar(nome: 'Editar Aula'),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: comprimento * paddingComprimento,
          vertical: altura * paddingAltura,
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: altura * distanciaItens),
              TextInputForm(
                controller: _salaController,
                label: 'Sala',
                obrigatorio: true,
              ),
              SizedBox(height: altura * distanciaInputs),
              Row(
                children: [
                  Text(
                    'Dia da Aula: ',
                    style: TextStyle(
                      color: corTexto,
                      fontSize: comprimento * tamanhoTexto,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    formatarDataDDMMYYYY(_diaSelecionado),
                    style: TextStyle(
                      color: corTexto,
                      fontSize: comprimento * tamanhoTexto,
                    ),
                  ),
                  const Spacer(),
                  DatePicker(
                    diaInicial: _diaSelecionado,
                    onDiaSelecionado: (novoDia) {
                      setState(() {
                        _diaSelecionado = novoDia;
                      });
                      _obterDiaSemana();
                    },
                  ),
                ],
              ),
              SizedBox(height: altura * distanciaInputs),
              PeriodoDropdown(
                valorSelecionadoID: _periodoSelecionado?.periodoID,
                periodos: _periodosDisponiveis,
                label: 'Selecionar Período',
                obrigatorio: true,
                onValueChanged: (novoID) {
                  setState(() {
                    _periodoSelecionado = _periodosDisponiveis.firstWhere(
                      (p) => p.periodoID == novoID,
                    );
                  });
                },
              ),
              SizedBox(height: altura * distanciaInputs),
              CadeiraDropdown(
                valorSelecionadoID: _cadeiraSelecionada?.cadeiraID,
                cadeiras: _cadeirasDisponiveis,
                label: 'Selecionar Cadeira',
                obrigatorio: true,
                onValueChanged: (novoID) {
                  setState(() {
                    _cadeiraSelecionada = _cadeirasDisponiveis.firstWhere(
                      (c) => c.cadeiraID == novoID,
                    );
                  });
                },
              ),
              SizedBox(height: altura * distanciaTemas),
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
                  'Guardar Aula',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MyNavigationBar(mostrarSelecionado: false),
    );
  }
}
