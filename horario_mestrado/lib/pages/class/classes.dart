import 'package:flutter/material.dart';
import 'package:horario_mestrado/variables/icons.dart';
// COMPONENTS
import '../../components/structure/navigation_bar.dart';
import '../../components/class_box.dart';
import '../../components/structure/app_bar.dart';
import '../../components/dropdown/dropdown_momento.dart';
import '../../components/dropdown/dropdown_tempo.dart';
// DATABASE
import '../../database/database_service.dart';
// MODELS
import '../../models/aula.dart';
//VARIABLES
import '../../variables/enums.dart';
import '../../variables/size.dart';

class AulasPage extends StatefulWidget {
  const AulasPage({super.key});

  @override
  State<AulasPage> createState() => _AulasPageState();
}

class _AulasPageState extends State<AulasPage> {
  final DataBaseService _dbService = DataBaseService();
  late Future<List<Aula>> _aulasFuture;

  Momento _momentoSelecionado = Momento.sempre;
  Tempo _tempoSelecionado = Tempo.semana;

  @override
  void initState() {
    super.initState();
    _carregarAulas(); //Inicialmente sem filtro
  }

  void _carregarAulas() {
    setState(() {
      _aulasFuture = _dbService.obterAulasFiltradasPorMomentoTempo(_momentoSelecionado.valorMomentoAulas, _tempoSelecionado);
    });
  }

  @override
  Widget build(BuildContext context) {
    //RESPONSIVIDADE
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    double altura = tamanho.height;

    return Scaffold(
      appBar: const MinhaAppBar(
        nome: 'Lista de Aulas',
        icon: iconAdicionar,
        rota: '/classAdd',
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: altura * paddingAltura,
          horizontal: comprimento * paddingComprimento,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TempoDropdown(
                    label: 'Quando',
                    valorSelecionado: _tempoSelecionado,
                    onValueChanged: (novoTempo) {
                      _tempoSelecionado = novoTempo!;
                      _carregarAulas();
                    },
                  ),
                ),
                SizedBox(width: comprimento * paddingComprimento),
                // Dropdown de filtro (Momento do dia)
                Expanded(
                  flex: 1,
                  child: MomentoDropdown(
                    valorSelecionado: _momentoSelecionado,
                    label: 'Estado',
                    onValueChanged: (novoMomento) {
                      _momentoSelecionado = novoMomento!;
                      _carregarAulas();
                    },
                  ),
                ),
                
                
              ],
            ),

            // Lista dinâmica das aulas
            Expanded(
              child: FutureBuilder<List<Aula>>(
                future: _aulasFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Nenhuma aula encontrada'));
                  }

                  final aulas = snapshot.data!;
                  return ListView.builder(
                    itemCount: aulas.length,
                    itemBuilder: (context, index) {
                      final aula = aulas[index];
                      return AulaBox(aula: aula);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MyNavigationBar(IconSelecionado: 3),
    );
  }
}
