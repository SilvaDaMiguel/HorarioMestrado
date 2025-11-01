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
import '../../components/form/submit_button.dart';
//FUNCTIONS
import '../../functions.dart';

class AulaAdicionar extends StatefulWidget {
  const AulaAdicionar({super.key});

  @override
  State<AulaAdicionar> createState() => _AulaAdicionarState();
}

class _AulaAdicionarState extends State<AulaAdicionar> {
  final DataBaseService _dbService = DataBaseService();
  final _formKey = GlobalKey<FormState>();

  // Controladores
  final TextEditingController _salaController = TextEditingController();

  //Outros inputs
  DateTime _diaSelecionado = DateTime.now();

  Periodo? _periodoSelecionado;
  List<Periodo> _periodosDisponiveis = [];
  Cadeira? _cadeiraSelecionada;
  List<Cadeira> _cadeirasDisponiveis = [];

  DiaSemana? diaSemana;

  @override
  void initState() {
    super.initState();
    _obterDiaSemana();
    _carregarPeriodos();
    _carregarCadeiras();
  }

  Future<void> _carregarPeriodos() async {
    final List<Periodo> periodos;
    periodos = await _dbService.obterPeriodosFiltradosDiaSemana(
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

  Future<void> _obterDiaSemana() async {
    setState(() {
      diaSemana = obterDiaSemana(_diaSelecionado);
    });
    print('Dia: ${formatarDataDDMMYYYY(_diaSelecionado)}');
    print('Dia da Semana: ${diaSemana!.nomeComAcento}');
    _carregarPeriodos();
  }

  @override
  void dispose() {
    _salaController.dispose();
    super.dispose();
  }

  Future<void> _guardarAula() async {
    if (_formKey.currentState!.validate()) {
      if (_periodoSelecionado == null) {
        MinhaSnackBar.mostrar(context, texto: 'Seleciona um período!');
        return;
      }
      if (_cadeiraSelecionada == null) {
        MinhaSnackBar.mostrar(context, texto: 'Seleciona uma cadeira!');
        return;
      }

      final novaAula = Aula(
        aulaID: await _dbService.obterNovoIDAula(),
        cadeiraID: _cadeiraSelecionada!.cadeiraID, //Nunca será Null
        periodoID: _periodoSelecionado!.periodoID, //Nunca será Null
        data: formatarDataDDMMYYYY(_diaSelecionado),
        sala: _salaController.text.trim(),
      );

      try {
        await _dbService.adicionarAula(novaAula);

        if (context.mounted) {
          //Volta para a pagina das aulas
          Navigator.pop(
            context,
            true,
          ); //Devolve True porque uma aula foi adicionada

          Future.microtask(() {
            MinhaSnackBar.mostrar(
              Navigator.of(context).context,
              texto: 'Aula adicionada com sucesso!',
            );
          });
        }
      } catch (e) {
        if (context.mounted) {
          MinhaSnackBar.mostrar(context, texto: 'Erro ao adicionar aula: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    double altura = tamanho.height;

    return Scaffold(
      appBar: const MinhaAppBar(nome: 'Adicionar Aula'),
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
                    onDiaSelecionado: (novoDia) {
                      setState(() {
                        _diaSelecionado = novoDia;
                      });
                      _obterDiaSemana(); //obter o dia da Semana para o filtro dos períodos
                    },
                    diaInicial: _diaSelecionado,
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
              BotaoSubmeter(
                texto: 'Adicionar Aula',
                aoPressionar: _guardarAula,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MyNavigationBar(mostrarSelecionado: false),
    );
  }
}
