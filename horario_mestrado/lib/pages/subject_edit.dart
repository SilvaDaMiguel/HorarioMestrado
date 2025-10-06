import 'package:flutter/material.dart';
//DATABASE
import '../database/database_service.dart';
//MODELS
import '../models/cadeira.dart';
//VARIABLES
import '../variables/colors.dart';
//COMPONENTS
import '../components/navigation_bar.dart';

class CadeiraEditar extends StatefulWidget {
  final Cadeira cadeira;

  const CadeiraEditar({super.key, required this.cadeira});

  @override
  State<CadeiraEditar> createState() => _CadeiraEditarState();
}

class _CadeiraEditarState extends State<CadeiraEditar> {
  final DataBaseService _dbService = DataBaseService();

  final _formKey = GlobalKey<FormState>();

  late String _nome;
  late String _sigla;
  late int _ano;
  late int _semestre;
  late String _informacao;
  late List<String> _professores;
  late int _creditos;
  late bool _concluida;
  double? _nota;

  @override
  void initState() {
    super.initState();
    //Preenche os campos com os valores iniciais
    final cadeiraInicial = widget.cadeira;
    _nome = cadeiraInicial.nome;
    _sigla = cadeiraInicial.sigla;
    _ano = cadeiraInicial.ano;
    _semestre = cadeiraInicial.semestre;
    _informacao = cadeiraInicial.informacao;
    _professores = List<String>.from(cadeiraInicial.professores ?? []);
    _creditos = cadeiraInicial.creditos;
    _concluida = cadeiraInicial.concluida;
    _nota = cadeiraInicial.nota;
  }

  Future<void> _guardarAlteracoes() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final cadeiraAtualizada = Cadeira(
        cadeiraID: widget.cadeira.cadeiraID,
        nome: _nome,
        sigla: _sigla,
        ano: _ano,
        semestre: _semestre,
        informacao: _informacao,
        professores: _professores,
        creditos: _creditos,
        concluida: _concluida,
        nota: _nota,
      );

      try {
        await _dbService.atualizarCadeira(cadeiraAtualizada);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cadeira atualizada com sucesso!')),
        );
        Navigator.pop(context, cadeiraAtualizada);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar cadeira: $e')),
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
              TextFormField(
                initialValue: _nome,
                decoration: const InputDecoration(labelText: 'Nome'),
                onSaved: (value) => _nome = value ?? '',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                initialValue: _sigla,
                decoration: const InputDecoration(labelText: 'Sigla'),
                onSaved: (value) => _sigla = value ?? '',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                initialValue: _ano.toString(),
                decoration: const InputDecoration(labelText: 'Ano'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _ano = int.tryParse(value ?? '0') ?? 0,
              ),
              TextFormField(
                initialValue: _semestre.toString(),
                decoration: const InputDecoration(labelText: 'Semestre'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _semestre = int.tryParse(value ?? '0') ?? 0,
              ),
              TextFormField(
                initialValue: _creditos.toString(),
                decoration: const InputDecoration(labelText: 'Créditos (ECTS)'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _creditos = int.tryParse(value ?? '0') ?? 0,
              ),
              TextFormField(
                initialValue: _informacao,
                decoration: const InputDecoration(labelText: 'Informação'),
                maxLines: 3,
                onSaved: (value) => _informacao = value ?? '',
              ),
              TextFormField(
                initialValue: _professores.join(', '),
                decoration: const InputDecoration(
                  labelText: 'Professores (separados por vírgula)',
                ),
                onSaved: (value) {
                  if (value != null && value.isNotEmpty) {
                    _professores =
                        value.split(',').map((e) => e.trim()).toList();
                  } else {
                    _professores = [];
                  }
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Cadeira concluída:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Checkbox(
                    value: _concluida,
                    onChanged: (value) {
                      setState(() => _concluida = value!);
                    },
                  ),
                ],
              ),
              if (_concluida)
                TextFormField(
                  initialValue: _nota?.toString() ?? '',
                  decoration: const InputDecoration(labelText: 'Nota final'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onSaved: (value) => _nota = double.tryParse(value ?? ''),
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
