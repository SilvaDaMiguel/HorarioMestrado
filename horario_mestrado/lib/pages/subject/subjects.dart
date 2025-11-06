import 'package:flutter/material.dart';
import 'package:horario_mestrado/variables/icons.dart';
// COMPONENTS
import '../../components/structure/navigation_bar.dart';
import '../../components/subject_box.dart';
import '../../components/structure/app_bar.dart';
import '../../components/dropdown/dropdown_filtroCadeira.dart';
// DATABASE
import '../../database/database_service.dart';
// MODELS
import '../../models/cadeira.dart';
//VARIABLES
import '../../variables/size.dart';
import '../../variables/enums.dart';
import '../../variables/colors.dart';

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
        //rota: '/subjectAdd',
        aoPressionar: () async {
          final resultado = await Navigator.pushNamed(context, '/subjectAdd');

          //Se a página de adicionar devolver true => Adicionado/Removido uma cadeira
          if (resultado == true) {
            print("Cadeira adicionada ou Apagada!!!");
            _carregarCadeiras(_filtroSelecionado); //Atualiza a lista
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
                        'Não foram encontradas Cadeiras do ${_filtroSelecionado.nomeFiltro}',
                        style: TextStyle(
                          color: corTexto,
                          fontSize: comprimento * tamanhoTexto,
                        ),
                      ),
                    );
                  }

                  final cadeiras = snapshot.data!;
                  return ListView.builder(
                    itemCount: cadeiras.length,
                    itemBuilder: (context, index) {
                      final cadeira = cadeiras[index];
                      return CadeiraBox(cadeira: cadeira, aoPressionar: () async {
                        final resultado = await Navigator.pushNamed(
                            context,
                            '/subjectInfo',
                            arguments: cadeira.cadeiraID, //ID do Objeto
                          );

                          //Se a página de adicionar devolver true => Adicionado/Removido uma Aula
                          if (resultado == true) {
                            _carregarCadeiras(_filtroSelecionado);
                          }
                      },);
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
