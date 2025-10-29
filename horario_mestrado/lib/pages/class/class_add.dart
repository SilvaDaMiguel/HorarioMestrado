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

  @override
  void initState() {
    super.initState();
    _carregarPeriodos();
    _carregarCadeiras();
  }

  Future<void> _carregarPeriodos() async {
    // TODO: No futuro -> buscar da base de dados filtrando pelo dia
    final periodos = await _dbService.obterPeriodos();
    setState(() {
      _periodosDisponiveis = periodos;
    });
  }
   Future<void> _carregarCadeiras() async {
    // TODO: No futuro -> buscar da base de dados filtrando pelo dia
    final cadeiras = await _dbService.obterCadeiras();
    setState(() {
      _cadeirasDisponiveis = cadeiras;
    });
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

      //TODO: adcionar aula
      /*
      try {
        await _dbService.adicionarAula(novaAula);

        if (context.mounted) {
          Navigator.pop(context, novaAula);
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
      */
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
              TextInputForm(
                controller: _salaController,
                label: 'Sala',
                obrigatorio: true,
              ),
              SizedBox(height: altura * distanciaItens),
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
                    },
                    diaInicial: _diaSelecionado,
                  ),
                ],
              ),
              SizedBox(height: altura * distanciaItens),
              PeriodoDropdown(
                valorSelecionado: _periodoSelecionado,
                periodos: _periodosDisponiveis,
                label: 'Selecionar Período',
                onValueChanged: (novo) {
                  setState(() {
                    _periodoSelecionado = novo;
                  });
                },
                obrigatorio: true,
              ),

              SizedBox(height: altura * distanciaItens),
              CadeiraDropdown(
                valorSelecionado: _cadeiraSelecionada,
                cadeiras: _cadeirasDisponiveis,
                label: 'Selecionar Cadeira',
                onValueChanged: (novo) {
                  setState(() {
                    _cadeiraSelecionada = novo;
                  });
                },
                obrigatorio: true,
              ),
              SizedBox(height: altura * distanciaTemas),
              //TODO: Botão Personalizado
              ElevatedButton(
                onPressed: _guardarAula,
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
