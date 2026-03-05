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
            //TODO: Carregar dados do JSON Local
            //TODO: Botão para Importar JSON locais
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
       
          ],
        ),
      ),
      bottomNavigationBar: MyNavigationBar(mostrarSelecionado: false),
    );
  }
}
