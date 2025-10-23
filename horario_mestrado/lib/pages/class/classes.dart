import 'package:flutter/material.dart';
// COMPONENTS
import '../../components/structure/navigation_bar.dart';
import '../../components/class_box.dart';
import '../../components/structure/app_bar.dart';
// DATABASE
import '../../database/database_service.dart';
// MODELS
import '../../models/aula.dart';

class AulasPage extends StatefulWidget {
  const AulasPage({super.key});

  @override
  State<AulasPage> createState() => _AulasPageState();
}

class _AulasPageState extends State<AulasPage> {
  final DataBaseService _dbService = DataBaseService();
  late Future<List<Aula>> _aulasFuture;

  @override
  void initState() {
    super.initState();
    _aulasFuture = _dbService.obterAulas();
  }

  @override
  Widget build(BuildContext context) {
    //RESPONSIVIDADE
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    double altura = tamanho.height;

    //PADDING
    double paddingAltura = altura * 0.05;
    double paddingComprimento = comprimento * 0.06;

    //TODO: Filtrar para esconder ou mostrar as aulas passadas (Por semana)
    return Scaffold(
      appBar: MinhaAppBar(nome: 'Lista de Aulas'),
      body: FutureBuilder<List<Aula>>(
        future: _aulasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aulas não encontradas'));
          }

          final aulas = snapshot.data!;

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
                  itemCount: aulas.length,
                  itemBuilder: (context, index) {
                    final aula = aulas[index];

                    return AulaBox(aula: aula);
                    //TODO: VERIFICAR se funciona
                  },
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: MyNavigationBar(IconSelecionado: 3),
    );
  }
}
