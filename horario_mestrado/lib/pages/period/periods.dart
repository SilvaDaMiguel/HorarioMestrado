import 'package:flutter/material.dart';
//COMPONENTS
import '../../components/structure/navigation_bar.dart';
import '../../components/period_box.dart';
import '../../components/structure/app_bar.dart';
//DATABASE
import '../../database/database_service.dart';
//MODELS
import '../../models/periodo.dart';

class PeriodosPage extends StatefulWidget {
  const PeriodosPage({super.key});

  @override
  State<PeriodosPage> createState() => _PeriodosPageState();
}

class _PeriodosPageState extends State<PeriodosPage> {
  final DataBaseService _dbService = DataBaseService();
  late Future<List<Periodo>> _periodosFuture;

  @override
  void initState() {
    super.initState();
    _periodosFuture = _dbService.obterPeriodos();
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

    return Scaffold(
      appBar: MinhaAppBar(nome: 'Lista de Periodos'),
      body: FutureBuilder<List<Periodo>>(
        future: _periodosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Períodos não encontrados'));
          }

          final periodos = snapshot.data!;

          //TODO: Adicionar Filtro por dia de Semana
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
                  itemCount: periodos.length,
                  itemBuilder: (context, index) {
                    final periodo = periodos[index];

                    return PeriodoBox(periodo: periodo);
                  },
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: MyNavigationBar(IconSelecionado: 2),
    );
  }
}
