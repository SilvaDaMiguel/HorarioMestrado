import 'package:flutter/material.dart';
// COMPONENTS
import '../components/structure/navigation_bar.dart';
import '../components/structure/app_bar.dart';
import '../components/dropdown/dropdown_filtroCadeira.dart';
import '../components/form/text_input_form.dart';
import '../components/form/submit_button.dart';
import '../components/structure/snack_bar.dart';
//SERVICES
import '../services/preference_service.dart';
//DATABASE
import '../database/storage_json.dart';
import '../database/database.dart';
import '../database/database_service.dart';
//VARIABLES
import '../../variables/size.dart';
import '../../variables/enums.dart';
import '../../variables/colors.dart';

class DefinicoesPage extends StatefulWidget {
  const DefinicoesPage({super.key});

  @override
  State<DefinicoesPage> createState() => _DefinicoesPageState();
}

class _DefinicoesPageState extends State<DefinicoesPage> {
  // preferências
  FiltroCadeiras? _filtroSelecionado;
  String? _salaSelecionada;
  late TextEditingController _salaController;

  late Future<void> _prefsFuture;

  @override
  void initState() {
    super.initState();
    _salaController = TextEditingController();
    _prefsFuture = _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _filtroSelecionado =
        await PreferenceService.loadFiltroCadeiras() ??
        FiltroCadeiras.ano1semestre1;
    _salaSelecionada = await PreferenceService.loadSalaDefault();
    _salaController.text = _salaSelecionada ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _prefsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

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
            //SALA DEFAULT
            TextInputForm(
              controller: _salaController,
              label: 'Sala Padrão (opcional)',
            ),
            SizedBox(height: altura * distanciaInputs),
            Center(
              child: BotaoSubmeter(
                texto: 'Guardar Sala',
                aoPressionar: () {
                  //atualiza e salva a sala
                  String? novaSala = _salaController.text.trim().isEmpty
                      ? null
                      : _salaController.text.trim();
                  setState(() {
                    _salaSelecionada = novaSala;
                  });
                  PreferenceService.saveSalaDefault(novaSala);
                  MinhaSnackBar.mostrar(
                    Navigator.of(context).context,
                    texto: 'Sala guardada com sucesso!',
                  );
                },
              ),
            ),
            SizedBox(height: altura * distanciaTemas),
            Text(
              'Exportar/Importar Dados - Avançado',
              style: TextStyle(
                fontSize: comprimento * tamanhoTexto,
                fontWeight: FontWeight.bold,
                color: corTexto,
              ),
            ),
            SizedBox(height: altura * distanciaItens),
            Center(
              child: BotaoSubmeter(
                texto: 'Exportar Dados (Backup)',
                aoPressionar: () async {
                  try {
                    await JsonStorage.exportarFicheiros();
                  } catch (e) {
                    MinhaSnackBar.mostrar(
                      context,
                      texto: 'Erro ao exportar ficheiros: $e',
                    );
                  }
                },
              ),
            ),
            SizedBox(height: altura * distanciaItens),
            Center(
              child: BotaoSubmeter(
                texto: 'Importar Dados (Restaurar)',
                aoPressionar: () async {
                  try {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) =>
                          const Center(child: CircularProgressIndicator()),
                    );

                    await JsonStorage.importarFicheiros();
                    await DataBaseService().resetBaseDeDados();

                    Navigator.pop(context); //Fecha o loading
                    MinhaSnackBar.mostrar(
                      context,
                      texto: 'Dados importados e Base de Dados atualizada!',
                    );

                    //Recarregar a app ou as preferências se necessário
                    _loadPreferences();
                  } catch (e) {
                    Navigator.pop(context); // Fecha o loading em caso de erro
                    MinhaSnackBar.mostrar(
                      context,
                      texto: 'Erro ao importar: $e',
                    );
                  }
                },
              ),
            ),
            SizedBox(height: altura * distanciaItens),
            Text(
              'Certifique-se de que tem um backup antes de importar. \nperiodos.json -> cadeiras.json -> aulas.json -> provas.json',
              style: TextStyle(
                fontSize: comprimento * tamanhoSubTexto,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      bottomNavigationBar: MyNavigationBar(mostrarSelecionado: false),
    );
  }
}
