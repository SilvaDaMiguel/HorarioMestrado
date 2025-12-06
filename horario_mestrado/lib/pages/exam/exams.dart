import 'package:flutter/material.dart';
import 'package:horario_mestrado/variables/icons.dart';
//COMPONENTS
import '../../components/structure/navigation_bar.dart';
import '../../components/exam_box.dart';
import '../../components/structure/app_bar.dart';
import '../../components/dropdown/dropdown_epoca.dart';
import '../../components/dropdown/dropdown_tipoProva.dart';
//DATABASE
import '../../database/database_service.dart';
//MODELS
import '../../models/prova.dart';
//SERVICES
import '../../services/preference_service.dart';
//VARIABLES
import '../../variables/size.dart';
import '../../variables/enums.dart';
import '../../variables/colors.dart';

class ProvasPage extends StatefulWidget {
  const ProvasPage({super.key});

  @override
  State<ProvasPage> createState() => _ProvasPageState();
}

class _ProvasPageState extends State<ProvasPage> {
  final DataBaseService _dbService = DataBaseService();
  late Future<List<Prova>> _provasFuture;

  Epoca _epocaSelecionada = Epoca.normal;
  TipoProva _tipoProvaSelecionado = TipoProva.exame;
  FiltroCadeiras _filtroCadeiras = FiltroCadeiras.ano1semestre1; //Filtro default para prevenir erros

  @override
  void initState() {
    super.initState();
    //Carrega imediatamente com o filtro default
    _carregarProvas();

    //Em background, vai buscar a preferência guardada e aplica se for diferente
    PreferenceService.loadFiltroCadeiras().then((filtroPreferido) {
      if (filtroPreferido != null && filtroPreferido != _filtroCadeiras) {
        setState(() {
          _filtroCadeiras = filtroPreferido;
        });
        _carregarProvas();
      }
    }).catchError((_) {
      //ignora erros e mantém o filtro default
      print('Preferência de Ano e Semestre não encontrada.');
    });
  }

  void _carregarProvas() {
    setState(() {
      //_provasFuture = _dbService.obterProvasFiltradas([_epocaSelecionada.nomeEpoca, _tipoProvaSelecionado.nomeTipoProva]);
      _provasFuture = _dbService.obterProvasFiltradasFiltroCadeira(_filtroCadeiras.valorFiltro, [_epocaSelecionada.nomeEpoca, _tipoProvaSelecionado.nomeTipoProva]);
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
        nome: 'Lista de Provas',
        icon: iconAdicionar,
        aoPressionar: () async {
          final resultado = await Navigator.pushNamed(context, '/examAdd');

          //Se a página de adicionar devolver true => Adicionado/Removido uma prova
          if (resultado == true) {
            print("Prova adicionada ou Apagada!!!");
            _carregarProvas(); //Atualiza a lista
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
                  child: EpocaDropdown(
                    label: 'Época',
                    valorSelecionado: _epocaSelecionada,
                    onValueChanged: (novoTempo) {
                      if (novoTempo != null) {
                        setState(() {
                          _epocaSelecionada = novoTempo;
                        });
                        _carregarProvas();
                      }
                    },
                  ),
                ),
                SizedBox(width: comprimento * paddingComprimento),
                Expanded(
                  flex: 1,
                  child: TipoProvaDropdown(
                    label: 'Tipo da Prova',
                    valorSelecionado: _tipoProvaSelecionado,
                    onValueChanged: (novoTipo) {
                      if (novoTipo != null) {
                        setState(() {
                          _tipoProvaSelecionado = novoTipo;
                        });
                        _carregarProvas();
                      }
                    },
                  ),
                ),
              ],
            ),
            //CONTEÚDO DINÂMICO (LISTA)
            Expanded(
              child: FutureBuilder<List<Prova>>(
                future: _provasFuture,
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
                        'Não foram encontradas Provas do ${_filtroCadeiras.nomeFiltro} para os filtros selecionados.',
                        style: TextStyle(
                          color: corTexto,
                          fontSize: comprimento * tamanhoTexto,
                        ),
                      ),
                    );
                  }

                  final provas = snapshot.data!;
                  return ListView.builder(
                    itemCount: provas.length,
                    itemBuilder: (context, index) {
                      final prova = provas[index];
                      return ProvaBox(prova: prova, aoPressionar: () async {
                          final resultado = await Navigator.pushNamed(
                            context,
                            '/examInfo',
                            arguments: prova.provaID, //ID do Objeto
                          );

                          //Se a página de adicionar devolver true => Adicionado/Removido uma Prova
                          if (resultado == true) {
                            _carregarProvas();
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
      bottomNavigationBar: MyNavigationBar(IconSelecionado: 4),
    );
  }
}
