import 'package:flutter/material.dart';
import 'package:horario_mestrado/variables/colors.dart';
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

  Momento _momentoSelecionado = Momento.agora;
  Tempo _tempoSelecionado = Tempo.semana;

  @override
  void initState() {
    super.initState();
    _carregarAulas(); //Inicialmente sem filtro
  }

  void _carregarAulas() {
    setState(() {
      _aulasFuture = _dbService.obterAulasFiltradasPorMomentoTempo(
        _momentoSelecionado,
        _tempoSelecionado,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    //RESPONSIVIDADE
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    double altura = tamanho.height;

    return Scaffold(
      appBar: MinhaAppBar(
        nome: 'Lista de Aulas',
        icon: iconAdicionar,
        //rota: '/classAdd',
        aoPressionar: () async {
          final resultado = await Navigator.pushNamed(context, '/classAdd');

          //Se a página de adicionar devolver true => Adicionado/Removido uma Aula
          if (resultado == true) {
            _carregarAulas();
          }
        },
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
                  child: MomentoDropdown(
                    valorSelecionado: _momentoSelecionado,
                    label: '',
                    onValueChanged: (novoMomento) {
                      _momentoSelecionado = novoMomento!;
                      _carregarAulas();
                    },
                  ),
                ),
                SizedBox(width: comprimento * paddingComprimento),
                Expanded(
                  flex: 1,
                  child: TempoDropdown(
                    label: '',
                    valorSelecionado: _tempoSelecionado,
                    onValueChanged: (novoTempo) {
                      _tempoSelecionado = novoTempo!;
                      _carregarAulas();
                    },
                  ),
                ),
              ],
            ),
            //SizedBox(height: altura * distanciaItens),
            // Lista dinâmica das aulas
            Expanded(
              child: FutureBuilder<List<Aula>>(
                future: _aulasFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Erro: ${snapshot.error}',
                        style: TextStyle(
                          color: corTexto,
                          fontSize: comprimento * tamanhoTexto,
                        ),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        'Nenhuma aula encontrada na(o) ${_tempoSelecionado.nomeTempo} ${_momentoSelecionado.momentoAulas}',
                        style: TextStyle(
                          color: corTexto,
                          fontSize: comprimento * tamanhoTexto,
                        ),
                      ),
                    );
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
