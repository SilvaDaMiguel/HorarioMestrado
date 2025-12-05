import 'package:flutter/material.dart';
// DATABASE
import '../../database/database_service.dart';
// MODELS
import '../../models/prova.dart';
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
import '../../components/dropdown/dropdown_cadeira.dart';
import '../../components/dropdown/dropdown_epoca.dart';
import '../../components/dropdown/dropdown_tipoProva.dart';
import '../../components/form/date_picker.dart';
import '../../components/form/time_picker.dart';
import '../../components/form/checkbox_form.dart';
import '../../components/form/submit_button.dart';
//FUNCTIONS
import '../../functions.dart';

class ProvaEditar extends StatefulWidget {
  final Prova prova;

  const ProvaEditar({super.key, required this.prova});

  @override
  State<ProvaEditar> createState() => _ProvaEditarState();
}

class _ProvaEditarState extends State<ProvaEditar> {
  final DataBaseService _dbService = DataBaseService();
  final _formKey = GlobalKey<FormState>();

  // Controladores
  late TextEditingController _salaController;
  late TextEditingController _informacaoController;
  late TextEditingController _notaController;

  //Outros inputs
  DateTime _diaSelecionado = DateTime.now();
  late TimeOfDay _horaInicioSelecionada;
  late TimeOfDay _horaFimSelecionada;

  late TipoProva _tipoProvaSelecionado;
  late Epoca _epocaSelecionada;

  Cadeira? _cadeiraSelecionada;
  List<Cadeira> _cadeirasDisponiveis = [];

  late bool _concluido;

  @override
  void initState() {
    super.initState();
    final provaInicial = widget.prova;

    _salaController = TextEditingController(text: provaInicial.sala);
    _informacaoController = TextEditingController(text: provaInicial.informacao);
    _notaController = TextEditingController(text: provaInicial.nota?.toString() ?? '');
    
    _concluido = provaInicial.concluido;

    _diaSelecionado = stringDDMMYYYYParaDateTime(provaInicial.data)!;//Nunca será Null
    _horaInicioSelecionada = stringParaTimeOfDay(provaInicial.horaInicio)!; //Nunca será Null
    _horaFimSelecionada = stringParaTimeOfDay(provaInicial.horaFim)!; //Nunca será Null
  
    _tipoProvaSelecionado = TipoProva.values.firstWhere(
      (tipo) => tipo.nomeTipoProva == provaInicial.tipo,
    );
    _epocaSelecionada = Epoca.values.firstWhere(
      (epoca) => epoca.nomeEpoca == provaInicial.epoca,
    );

    _carregarCadeiras();
  }

  Future<void> _carregarCadeiras() async {
    final cadeiras = await _dbService.obterCadeiras();
    final cadeiraInicial = await _dbService.obterCadeiraPorId(widget.prova.cadeiraID);
    setState(() {
      _cadeirasDisponiveis = cadeiras;
      _cadeiraSelecionada = cadeiraInicial;
    });
  }

  @override
  void dispose() {
    _salaController.dispose();
    _informacaoController.dispose();
    _notaController.dispose();
    super.dispose();
  }

  Future<void> _guardarAlteracoes() async {
    if (_formKey.currentState!.validate()) {
      if (!verificarHoraInicioFim(
        _horaInicioSelecionada,
        _horaFimSelecionada,
      )) {
        MinhaSnackBar.mostrar(context, texto: 'Selecione uma hora válida!');
        return;
      }

      if (_cadeiraSelecionada == null) {
        MinhaSnackBar.mostrar(context, texto: 'Seleciona uma cadeira!');
        return;
      }

      final nota = _concluido
          ? double.tryParse(_notaController.text.trim())
          : null;

      final sala = _salaController.text.isEmpty
          ? '?'
          : _salaController.text.trim();
      final informacao = _informacaoController.text.isEmpty
          ? 'Sem informação'
          : _informacaoController.text.trim();

      final provaAtualizada = Prova(
        provaID: widget.prova.provaID,
        cadeiraID: _cadeiraSelecionada!.cadeiraID, //Nunca será Null
        sala: sala, //Pode ser ? para o caso de ainda não ter sido definida
        data: formatarDataDDMMYYYY(_diaSelecionado),
        horaInicio: timeOfDayParaString(_horaInicioSelecionada),
        horaFim: timeOfDayParaString(_horaFimSelecionada),
        tipo: _tipoProvaSelecionado.nomeTipoProva,
        epoca: _epocaSelecionada.nomeEpoca,
        informacao: informacao,
        concluido: _concluido,
        nota: nota,
      );

      try {
        await _dbService.atualizarProva(provaAtualizada);

        if (context.mounted) {
          //Volta para a pagina das provas
          Navigator.pop(
            context,
            provaAtualizada,
          ); 

          Future.microtask(() {
            MinhaSnackBar.mostrar(
              Navigator.of(context).context,
              texto: 'Prova atualizada com sucesso!',
            );
          });
        }
      } catch (e) {
        if (context.mounted) {
          MinhaSnackBar.mostrar(context, texto: 'Erro ao atualizar prova: $e');
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
      appBar: const MinhaAppBar(nome: 'Adicionar Prova'),
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
              SizedBox(height: altura * distanciaInputs),
              TipoProvaDropdown(
                valorSelecionado: _tipoProvaSelecionado,
                label: 'Selecionar Tipo',
                obrigatorio: true,
                onValueChanged: (novoValor) {
                  if (novoValor != null) {
                    setState(() {
                      _tipoProvaSelecionado = novoValor;
                    });
                  }
                },
              ),
              SizedBox(height: altura * distanciaInputs),
              EpocaDropdown(
                valorSelecionado: _epocaSelecionada,
                label: 'Selecionar Época',
                obrigatorio: true,
                onValueChanged: (novoValor) {
                  if (novoValor != null) {
                    setState(() {
                      _epocaSelecionada = novoValor;
                    });
                  }
                },
              ),
              SizedBox(height: altura * distanciaInputs),
              Row(
                children: [
                  Text(
                    'Dia da Prova: ',
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
              SizedBox(height: altura * distanciaInputs),
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
              SizedBox(height: altura * distanciaInputs),
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
              SizedBox(height: altura * distanciaInputs),
              TextInputForm(controller: _salaController, label: 'Sala'),
              SizedBox(height: altura * distanciaInputs),
              TextInputForm(
                controller: _informacaoController,
                label: 'Informação',
                maxLinhas: 3,
                maxCaracteres: 500,
              ),
              SizedBox(height: altura * distanciaInputs),
              Row(
                children: [
                  Text(
                    'Prova concluída?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: corTexto,
                      fontSize: comprimento * tamanhoTexto,
                    ),
                  ),
                  CheckboxForm(
                    valor: _concluido,
                    aoMudar: (value) {
                      setState(() {
                        _concluido = value ?? false;
                        if (!_concluido) _notaController.clear();
                      });
                    },
                  ),
                ],
              ),
              if (_concluido) SizedBox(height: altura * distanciaInputs),
              if (_concluido)
                TextInputForm(
                  controller: _notaController,
                  label: 'Nota',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  maxCaracteres: 6,
                ),
              SizedBox(height: altura * distanciaTemas),
              BotaoSubmeter(
                texto: 'Guardar Alterações',
                aoPressionar: _guardarAlteracoes,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MyNavigationBar(mostrarSelecionado: false),
    );
  }
}
