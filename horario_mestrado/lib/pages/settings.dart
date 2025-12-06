import 'package:flutter/material.dart';
// COMPONENTS
import '../../components/structure/navigation_bar.dart';
import '../../components/subject_box.dart';
import '../../components/structure/app_bar.dart';
import '../../components/dropdown/dropdown_filtroCadeira.dart';
import '../../components/structure/snack_bar.dart';
import '../../components/structure/snack_bar_confirmation.dart';
import '../../components/round_icon_button.dart';
// DATABASE
import '../../database/database_service.dart';
// MODELS
import '../../models/cadeira.dart';
//SERVICES
import '../services/preference_service.dart';
//VARIABLES
import '../../variables/size.dart';
import '../../variables/enums.dart';
import '../../variables/colors.dart';
import '../../variables/icons.dart';

class DefinicoesPage extends StatefulWidget {
  const DefinicoesPage({super.key});

  @override
  State<DefinicoesPage> createState() => _DefinicoesPageState();
}

class _DefinicoesPageState extends State<DefinicoesPage> {
  final DataBaseService _dbService = DataBaseService();
  FiltroCadeiras? _filtroSelecionado;
  late Future<FiltroCadeiras?> _filtroFuture;

  @override
  void initState() {
    super.initState();
    _filtroFuture = PreferenceService.loadFiltroCadeiras();
  }
  

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FiltroCadeiras?>(
      future: _filtroFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        //Resolve o valor do filtro (cai para o default se null)
        _filtroSelecionado ??= snapshot.data ?? FiltroCadeiras.ano1semestre1;

        //Agora retorna a UI normal
        return _buildScaffold(context);
      },
    );
  }

  //Extrai o scaffold para uma função separada para ficar mais legível
  Widget _buildScaffold(BuildContext context) {
    //RESPONSIVIDADE
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    double altura = tamanho.height;

    return Scaffold(
      appBar: MinhaAppBar(nome: 'Definições'),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: altura * paddingAltura,
          horizontal: comprimento * paddingComprimento,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ano e Semestre Atual',
              style: TextStyle(
                fontSize: comprimento * tamanhoTexto,
                fontWeight: FontWeight.bold,
                color: corTexto,
              ),
            ),
            SizedBox(height: altura * distanciaItens),
            //Dropdown de Filtro
            FiltroCadeiraDropdown(
              valorSelecionado: _filtroSelecionado!,
              label: '',
              onValueChanged: (novoFiltro) {
                if (novoFiltro != null) {
                  setState(() {
                    _filtroSelecionado = novoFiltro;
                  });
                  PreferenceService.saveFiltroCadeiras(novoFiltro);
                }
              },
              obrigatorio: false,
            ),
            SizedBox(height: altura * distanciaTemas),
            //TODO: Carregar dados do JSON Local
            //TODO: Botão para Importar JSON locais
            //TODO: Botão para Exportar JSON locais
          ],
        ),
      ),
      bottomNavigationBar: MyNavigationBar(mostrarSelecionado: false),
    );
  }
}