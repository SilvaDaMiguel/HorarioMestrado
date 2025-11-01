import 'package:flutter/material.dart';
import 'package:horario_mestrado/variables/enums.dart';
import 'package:horario_mestrado/variables/icons.dart';
import 'package:horario_mestrado/variables/size.dart';
// COMPONENTS
import '../../components/structure/navigation_bar.dart';
import '../../components/period_box.dart';
import '../../components/structure/app_bar.dart';
import '../../components/dropdown/dropdown_diaSemana.dart';
// DATABASE
import '../../database/database_service.dart';
// MODELS
import '../../models/periodo.dart';
//VARIABLES
import '../../variables/colors.dart';

class PeriodosPage extends StatefulWidget {
  const PeriodosPage({super.key});

  @override
  State<PeriodosPage> createState() => _PeriodosPageState();
}

class _PeriodosPageState extends State<PeriodosPage> {
  final DataBaseService _dbService = DataBaseService();
  late Future<List<Periodo>> _periodosFuture;
  DiaSemana? _diaSelecionado;

  @override
  void initState() {
    super.initState();
    _carregarPeriodos(); // Inicialmente, sem filtro
  }

  void _carregarPeriodos({DiaSemana? dia}) {
    setState(() {
      if (dia == null) {
        _periodosFuture = _dbService.obterPeriodos();
      } else {
        _periodosFuture = _dbService.obterPeriodosFiltradosDiaSemana(
          dia.nomeComAcento,
        );
      }
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
        nome: 'Lista de Períodos',
        icon: iconAdicionar,
        //rota: '/periodAdd',
        aoPressionar: () async {
          final resultado = await Navigator.pushNamed(context, '/subjectAdd');

          //Se a página de adicionar devolver true => Adicionado/Removido um Periodo
          if (resultado == true) {
            _carregarPeriodos(dia: _diaSelecionado); //Atualiza a lista
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
            //Dropdown do Dia da Semana
            DiaSemanaDropdown(
              valorSelecionado: _diaSelecionado,
              onValueChanged: (novoDia) {
                _diaSelecionado = novoDia;
                _carregarPeriodos(dia: novoDia);
              },
            ),
            //SizedBox(height: altura * distanciaTemas),

            //LISTA DINÂMICA (FUTUREBUILDER)
            Expanded(
              child: FutureBuilder<List<Periodo>>(
                future: _periodosFuture,
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
                        'Não foi encontrado nenhum Período na(o) ${_diaSelecionado!.nomeComAcento}',
                        style: TextStyle(
                          color: corTexto,
                          fontSize: comprimento * tamanhoTexto,
                        ),
                      ),
                    );
                  }

                  final periodos = snapshot.data!;
                  return ListView.builder(
                    itemCount: periodos.length,
                    itemBuilder: (context, index) {
                      final periodo = periodos[index];
                      return PeriodoBox(periodo: periodo);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MyNavigationBar(IconSelecionado: 2),
    );
  }
}
