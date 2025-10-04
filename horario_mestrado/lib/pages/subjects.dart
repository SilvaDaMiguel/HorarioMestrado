import 'package:flutter/material.dart';
// COMPONENTS
import '../components/navigation_bar.dart';
import '../components/subject_box.dart';
// VARIABLES
import '../variables/colors.dart';
// DATABASE
import '../database/database_service.dart';
// MODELS
import '../models/cadeira.dart';

class CadeirasPage extends StatefulWidget {
  const CadeirasPage({super.key});

  @override
  State<CadeirasPage> createState() => _CadeirasPageState();
}

class _CadeirasPageState extends State<CadeirasPage> {
  final DataBaseService _dbService = DataBaseService();
  late Future<List<Cadeira>> _cadeirasFuture;

  @override
  void initState() {
    super.initState();
    _cadeirasFuture = _dbService.obterCadeiras();
  }

  @override
  Widget build(BuildContext context) {
    //RESPONSIVIDADE
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    double altura = tamanho.height;

    //TEXTO
    double tamanhoTexto = comprimento * 0.04;
    double tamanhoTitulo = comprimento * 0.05;
    double tamanhoSubTexto = tamanhoTexto * 0.8;

    //PADDING
    double paddingAltura = altura * 0.05;
    double paddingComprimento = comprimento * 0.06;

    //OUTROS
    double tamanhoIcon = comprimento * 0.05;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lista de Cadeiras',
          style: TextStyle(color: corTexto),
        ),
        centerTitle: true,
        backgroundColor: corPrimaria,
      ),
      body: FutureBuilder<List<Cadeira>>(
        future: _cadeirasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Cadeiras não encontradas'));
          }

          final cadeiras = snapshot.data!;

          //TODO: Adicionar Dropdown filtro por Ano e Semestre
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: paddingAltura,
              horizontal: paddingComprimento,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: cadeiras.length,
                  itemBuilder: (context, index) {
                    final cadeira = cadeiras[index];

                    return SubjectBox(cadeira: cadeira);
                  },
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: MyNavigationBar(IconSelecionado: 1),
    );
  }
}
