//subject_edit.dart
import 'package:flutter/material.dart';
//DATABASE
import '../../database/database_service.dart';
//MODELS
import '../../models/cadeira.dart';
//VARIABLES
import '../../variables/colors.dart';
import '../../variables/enums.dart';
import '../../variables/size.dart';
//COMPONENTS
import '../../components/structure/navigation_bar.dart';
import '../../components/structure/app_bar.dart';
import '../../components/structure/snack_bar.dart';
import '../../components/form/text_input_form.dart';
import '../../components/form/checkbox_form.dart';
import '../../components/dropdown/dropdown_filtroCadeira.dart';

class CadeiraEditar extends StatefulWidget {
  final Cadeira cadeira;

  const CadeiraEditar({super.key, required this.cadeira});

  @override
  State<CadeiraEditar> createState() => _CadeiraEditarState();
}

class _CadeiraEditarState extends State<CadeiraEditar> {
  final DataBaseService _dbService = DataBaseService();
  final _formKey = GlobalKey<FormState>();

  // Controladores para cada campo
  late TextEditingController _nomeController;
  late TextEditingController _siglaController;
  late TextEditingController _creditosController;
  late TextEditingController _informacaoController;
  late TextEditingController _professoresController;
  late TextEditingController _notaController;

  late int _ano;
  late int _semestre;
  late bool _concluida;

  @override
  void initState() {
    super.initState();
    final cadeiraInicial = widget.cadeira;

    _nomeController = TextEditingController(text: cadeiraInicial.nome);
    _siglaController = TextEditingController(text: cadeiraInicial.sigla);
    _creditosController = TextEditingController(
      text: cadeiraInicial.creditos.toString(),
    );
    _informacaoController = TextEditingController(
      text: cadeiraInicial.informacao,
    );
    _professoresController = TextEditingController(
      text: (cadeiraInicial.professores ?? []).join(', '),
    );
    _notaController = TextEditingController(
      text: cadeiraInicial.nota?.toString() ?? '',
    );

    _ano = cadeiraInicial.ano;
    _semestre = cadeiraInicial.semestre;
    _concluida = cadeiraInicial.concluida;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _siglaController.dispose();
    _creditosController.dispose();
    _informacaoController.dispose();
    _professoresController.dispose();
    _notaController.dispose();
    super.dispose();
  }

  Future<void> _guardarAlteracoes() async {
    if (_formKey.currentState!.validate()) {
      final nome = _nomeController.text.trim();
      final sigla = _siglaController.text.trim();
      final creditos = int.tryParse(_creditosController.text.trim()) ?? 0;
      final informacao = _informacaoController.text.trim();
      final professores = _professoresController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      final nota = _concluida
          ? double.tryParse(_notaController.text.trim())
          : null;

      final cadeiraAtualizada = Cadeira(
        cadeiraID: widget.cadeira.cadeiraID,
        nome: nome,
        sigla: sigla,
        ano: _ano,
        semestre: _semestre,
        informacao: informacao,
        professores: professores,
        creditos: creditos,
        concluida: _concluida,
        nota: nota,
      );

      try {
        await _dbService.atualizarCadeira(cadeiraAtualizada);
        MinhaSnackBar.mostrar(context, texto: 'Cadeira atualizada com sucesso!');
        Navigator.pop(context, cadeiraAtualizada);
      } catch (e) {
        MinhaSnackBar.mostrar(context, texto: 'Erro ao editar cadeira: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    double altura = tamanho.height;

    return Scaffold(
      appBar: MinhaAppBar(nome: 'Editar Informação da Cadeira'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: comprimento * paddingComprimento, vertical: altura * paddingAltura),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: altura * distanciaItens),
              TextInputForm(
                controller: _nomeController,
                label: 'Nome',
                obrigatorio: true,
              ),
              SizedBox(height: altura * distanciaTemas),
              TextInputForm(
                controller: _siglaController,
                label: 'Sigla',
                obrigatorio: true,
              ),
              SizedBox(height: altura * distanciaTemas),
              FiltroCadeiraDropdown(
                valorSelecionado: FiltroCadeiras.values.firstWhere(
                  (filtro) =>
                      filtro.valorFiltro[0] == _ano &&
                      filtro.valorFiltro[1] == _semestre,
                  orElse: () => FiltroCadeiras.ano1semestre1,
                ),
                label: 'Selecionar Ano e Semestre',
                onValueChanged: (novoFiltro) {
                  if (novoFiltro != null) {
                    setState(() {
                      _ano = novoFiltro.valorFiltro[0];
                      _semestre = novoFiltro.valorFiltro[1];
                    });
                  }
                },
                obrigatorio: true,
              ),
              SizedBox(height: altura * distanciaTemas),
              TextInputForm(
                controller: _creditosController,
                label: 'Créditos (ECTS)',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: altura * distanciaTemas),
              TextInputForm(
                controller: _informacaoController,
                label: 'Informação',
                maxLinhas: 3,
              ),
              SizedBox(height: altura * distanciaTemas),
              TextInputForm(
                controller: _professoresController,
                label: 'Professores (separados por vírgula)',
              ),
              SizedBox(height: altura * distanciaTemas),
              Row(
                children: [
                  Text(
                    'Cadeira concluída?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: corTexto,
                      fontSize: comprimento * tamanhoTexto,
                    ),
                  ),
                  CheckboxForm(
                    valor: _concluida,
                    aoMudar: (value) {
                      setState(() {
                        _concluida = value ?? false;
                        if (!_concluida) _notaController.clear();
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: altura * distanciaItens),
              if (_concluida)
                TextInputForm(
                  controller: _notaController,
                  label: 'Nota final',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
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
                //TODO: Botão Customizado
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
