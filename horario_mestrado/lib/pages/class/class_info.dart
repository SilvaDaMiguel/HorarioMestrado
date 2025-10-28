import 'package:flutter/material.dart';
//DATABASE
import '../../database/database_service.dart';
//MODELS
import '../../models/aula.dart';
import '../../models/cadeira.dart';
import '../../models/periodo.dart';
//VARIABLES
import '../../variables/colors.dart';
import '../../variables/icons.dart';
import '../../variables/size.dart';
//COMPONENTS
import '../../components/round_icon_button.dart';
import '../../components/structure/app_bar.dart';
import '../../components/structure/snack_bar.dart';

class AulaInformacao extends StatefulWidget {
  final int aulaID;
  const AulaInformacao({super.key, required this.aulaID});

  @override
  State<AulaInformacao> createState() => _AulaInformacaoState();
}

class _AulaInformacaoState extends State<AulaInformacao> {
  final DataBaseService _dbService = DataBaseService();
  late Future<Map<String, dynamic>> _dadosCompletosFuture;

  @override
  void initState() {
    super.initState();
    _dadosCompletosFuture = _carregarDados();
  }

  Future<Map<String, dynamic>> _carregarDados() async {
    final aula = await _dbService.obterAulaPorId(widget.aulaID);
    final cadeira = await _dbService.obterCadeiraPorId(aula.cadeiraID);
    final periodo = await _dbService.obterPeriodoPorId(aula.periodoID);

    return {'aula': aula, 'cadeira': cadeira, 'periodo': periodo};
  }

  @override
  Widget build(BuildContext context) {
    final tamanho = MediaQuery.of(context).size;
    final comprimento = tamanho.width;
    final altura = tamanho.height;

    return FutureBuilder<Map<String, dynamic>>(
      future: _dadosCompletosFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Erro: ${snapshot.error}')));
        } else if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: Text('Dados não encontrados')),
          );
        }

        final aula = snapshot.data!['aula'] as Aula;
        final cadeira = snapshot.data!['cadeira'] as Cadeira;
        final periodo = snapshot.data!['periodo'] as Periodo;

        return Scaffold(
          appBar: MinhaAppBar(
            nome: 'Informação da Aula',
            icon: iconEditar,
            rota: '/error',
            argumento: aula,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: altura * paddingAltura,
              horizontal: comprimento * paddingComprimento,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aula do dia ${aula.data}, ${periodo.diaSemana}',
                  style: TextStyle(
                    fontSize: comprimento * tamanhoTitulo,
                    fontWeight: FontWeight.bold,
                    color: corTexto,
                  ),
                ),
                SizedBox(height: altura * distanciaItens),
                Row(
                  children: [
                    Icon(
                      iconHora,
                      size: comprimento * tamanhoIcon,
                      color: corTerciaria,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${periodo.horaInicio} - ${periodo.horaFim}',
                      style: TextStyle(
                        fontSize: comprimento * tamanhoTexto,
                        fontWeight: FontWeight.bold,
                        color: corTexto,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      iconSala,
                      size: comprimento * tamanhoIcon,
                      color: corTerciaria,
                    ),
                    SizedBox(width: 8),
                    Text(
                      aula.sala,
                      style: TextStyle(
                        fontSize: comprimento * tamanhoTexto,
                        color: corTexto,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: altura * distanciaTemas),
                //OUTRAS INFORMAÇÕES
                Text(
                  'Outras Informações:',
                  style: TextStyle(
                    fontSize: comprimento * tamanhoTitulo,
                    color: corTexto,
                  ),
                ),
                SizedBox(height: altura * distanciaItens),
                Text(
                  '${cadeira.sigla} - ${cadeira.nome}',
                  style: TextStyle(
                    fontSize: comprimento * tamanhoTexto,
                    fontWeight: FontWeight.bold,
                    color: corTexto,
                  ),
                ),
                SizedBox(height: altura * distanciaItens),
                Text(
                  '${cadeira.ano}º Ano ${cadeira.semestre}º Semestre',
                  style: TextStyle(
                    color: corTexto,
                    fontSize: comprimento * tamanhoTexto,
                  ),
                ),
                SizedBox(height: altura * distanciaTemas),
                //BOTÃO APAGAR
                Center(
                  child: IconBotaoRedondo(
                    corIcon: Colors.red,
                    aoSelecionar: () async {
                      try {
                        //Tenta apagar a aula
                        await _dbService.apagarAula(aula.aulaID);

                        //Se for bem-sucedido, volta à página das aulas
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/classes',
                            (route) => false,
                          );
                          Future.microtask(() {
                            MinhaSnackBar.mostrar(
                              Navigator.of(context).context,
                              texto: 'Aula apagada com sucesso!',
                            );
                          });
                        }
                      } catch (e) {
                        //Mostra o snack-bar de erro se algo falhar
                        if (context.mounted) {
                          MinhaSnackBar.mostrar(
                            context,
                            texto: e.toString().contains('aula')
                                ? 'Não é possível apagar a aula.' //Para não aparecer o "Exception:"
                                : 'Ocorreu um erro ao apagar a aula.',
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
