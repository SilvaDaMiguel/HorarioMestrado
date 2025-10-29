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

class CadeiraAdicionar extends StatefulWidget {
  const CadeiraAdicionar({super.key});

  @override
  State<CadeiraAdicionar> createState() => _CadeiraAdicionarState();
}

class _CadeiraAdicionarState extends State<CadeiraAdicionar> {
  final DataBaseService _dbService = DataBaseService();
  final _formKey = GlobalKey<FormState>();

  // Controladores para cada campo
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _siglaController = TextEditingController();
  final TextEditingController _creditosController = TextEditingController();
  final TextEditingController _informacaoController = TextEditingController();
  final TextEditingController _professoresController = TextEditingController();
  final TextEditingController _notaController = TextEditingController();

  int _ano = 1; //Valor padrão
  int _semestre = 1; //Valor padrão
  bool _concluida = false;

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

      final cadeiraAdicionada = Cadeira(
        cadeiraID: await _dbService.obterNovoIDCadeira(),
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
      //print('Cadeira: ${cadeiraAdicionada.cadeiraID}, ${cadeiraAdicionada.nome}');
      try {
        await _dbService.adicionarCadeira(cadeiraAdicionada);

        if (context.mounted) {
          //Volta para a página das cadeiras
          Navigator.pop(context, cadeiraAdicionada);

          // Show snackbar in the previous screen's context
          Future.microtask(() {
            MinhaSnackBar.mostrar(
              Navigator.of(context).context,
              texto: 'Cadeira adicionada com sucesso!',
              botao: 'Ver',
              rota: '/subjectInfo',
              argumento: cadeiraAdicionada.cadeiraID,
            );
          });
        }
      } catch (e) {
        if (context.mounted) {
          MinhaSnackBar.mostrar(
            context,
            texto: 'Erro ao adicionar cadeira: $e',
          );
        }
        //print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    double altura = tamanho.height;

    return Scaffold(
      appBar: MinhaAppBar(nome: 'Adicionar Cadeira'),
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
                controller: _nomeController,
                label: 'Nome',
                obrigatorio: true,
              ),
              SizedBox(height: altura * distanciaInputs),
              TextInputForm(
                controller: _siglaController,
                label: 'Sigla',
                obrigatorio: true,
              ),
              SizedBox(height: altura * distanciaInputs),
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
              SizedBox(height: altura * distanciaInputs),
              TextInputForm(
                controller: _creditosController,
                label: 'Créditos (ECTS)',
                keyboardType: TextInputType.number,
                obrigatorio: true,
              ),
              SizedBox(height: altura * distanciaInputs),
              TextInputForm(
                controller: _informacaoController,
                label: 'Informação',
                maxLinhas: 3,
              ),
              SizedBox(height: altura * distanciaInputs),
              TextInputForm(
                controller: _professoresController,
                label: 'Professores (separados por vírgula)',
              ),
              SizedBox(height: altura * distanciaInputs),
              Row(
                children: [
                  const Text(
                    'Cadeira concluída?',
                    style: TextStyle(fontWeight: FontWeight.bold),
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
              if (_concluida) SizedBox(height: altura * distanciaInputs),
              if (_concluida)
                TextInputForm(
                  controller: _notaController,
                  label: 'Nota final',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              SizedBox(height: altura * distanciaTemas),
              //TODO: Botão Custom
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
