import 'package:flutter/material.dart';
import 'package:horario_mestrado/variables/icons.dart';
// COMPONENTS
import '../../components/structure/navigation_bar.dart';
import '../../components/subject_box.dart';
import '../../components/structure/app_bar.dart';
import '../../components/form/dropdown_filtroCadeira.dart';
// DATABASE
import '../../database/database_service.dart';
// MODELS
import '../../models/cadeira.dart';
//VARIABLES
import '../../variables/size.dart';
import '../../variables/enums.dart';

class CadeirasPage extends StatefulWidget {
  const CadeirasPage({super.key});

  @override
  State<CadeirasPage> createState() => _CadeirasPageState();
}

class _CadeirasPageState extends State<CadeirasPage> {
  final DataBaseService _dbService = DataBaseService();
  late Future<List<Cadeira>> _cadeirasFuture;
  FiltroCadeiras _filtroSelecionado = FiltroCadeiras.ano1semestre1;

  @override
  void initState() {
    super.initState();
    _carregarCadeiras(_filtroSelecionado);
  }

  void _carregarCadeiras(FiltroCadeiras filtro) {
    setState(() {
      _cadeirasFuture = _dbService.obterCadeirasFiltradas(filtro.valorFiltro);
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
        nome: 'Lista de Cadeiras',
        icon: iconAdicionar,
        rota: '/subjectAdd',
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: altura * paddingAltura,
          horizontal: comprimento * paddingComprimento,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Dropdown de Filtro
            FiltroCadeiraDropdown(
              valorSelecionado: _filtroSelecionado,
              label: 'Filtrar por Ano e Semestre',
              onValueChanged: (novoFiltro) {
                if (novoFiltro != null) {
                  _filtroSelecionado = novoFiltro;
                  _carregarCadeiras(novoFiltro);
                }
              },
              obrigatorio: false,
            ),
            //SizedBox(height: altura * distanciaTemas),
            //CONTEÚDO DINÂMICO (LISTA)
            Expanded(
              child: FutureBuilder<List<Cadeira>>(
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
                  return ListView.builder(
                    itemCount: cadeiras.length,
                    itemBuilder: (context, index) {
                      final cadeira = cadeiras[index];
                      return CadeiraBox(cadeira: cadeira);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MyNavigationBar(IconSelecionado: 1),
    );
  }
}
