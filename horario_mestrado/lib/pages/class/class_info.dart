import 'package:flutter/material.dart';
// DATABASE
import '../../database/database_service.dart';
// MODELS
import '../../models/aula.dart';
import '../../models/cadeira.dart';
import '../../models/periodo.dart';
// VARIABLES
import '../../variables/colors.dart';
import '../../variables/icons.dart';
import '../../variables/size.dart';
// COMPONENTS
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
  late Future<Aula> _aulaFuture;
  Cadeira? _cadeira;
  Periodo? _periodo;

  @override
  void initState() {
    super.initState();
    _aulaFuture = _carregarAula();
  }

  Future<Aula> _carregarAula() async {
    final aula = await _dbService.obterAulaPorId(widget.aulaID);
    _cadeira = await _dbService.obterCadeiraPorId(aula.cadeiraID);
    _periodo = await _dbService.obterPeriodoPorId(aula.periodoID);
    return aula;
  }

  @override
  Widget build(BuildContext context) {
    final tamanho = MediaQuery.of(context).size;
    final comprimento = tamanho.width;
    final altura = tamanho.height;

    return FutureBuilder<Aula>(
      future: _aulaFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Erro ao carregar dados da aula.'),
            ),
          );
        } else if (!snapshot.hasData || _cadeira == null || _periodo == null) {
          return const Scaffold(
            body: Center(child: Text('Aula não encontrada.')),
          );
        }

        final aula = snapshot.data!;
        final cadeira = _cadeira!;
        final periodo = _periodo!;

        return Scaffold(
          appBar: MinhaAppBar(
            nome: 'Informação da Aula',
            icon: iconEditar,
            aoPressionar: () async {
              final aulaAtualizada = await Navigator.pushNamed(
                context,
                '/classEdit',
                arguments: aula,
              );

              if (aulaAtualizada is Aula) {
                setState(() {
                  _aulaFuture = Future.value(aulaAtualizada);
                });
              }
            },
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: altura * paddingAltura,
              horizontal: comprimento * paddingComprimento,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TÍTULO
                Text(
                  'Aula do dia ${aula.data}, ${periodo.diaSemana}',
                  style: TextStyle(
                    fontSize: comprimento * tamanhoTitulo,
                    fontWeight: FontWeight.bold,
                    color: corTexto,
                  ),
                ),
                SizedBox(height: altura * distanciaItens),

                // HORA
                Row(
                  children: [
                    Icon(
                      iconHora,
                      size: comprimento * tamanhoIcon,
                      color: corTerciaria,
                    ),
                    const SizedBox(width: 8),
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
                SizedBox(height: altura * distanciaItens),

                // SALA
                Row(
                  children: [
                    Icon(
                      iconSala,
                      size: comprimento * tamanhoIcon,
                      color: corTerciaria,
                    ),
                    const SizedBox(width: 8),
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

                // OUTRAS INFORMAÇÕES
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

                // BOTÃO APAGAR
                Center(
                  child: IconBotaoRedondo(
                    corIcon: Colors.red,
                    aoSelecionar: () async {
                      try {
                        await _dbService.apagarAula(aula.aulaID);

                        if (context.mounted) {
                          Navigator.pop(context, true);
                          Future.microtask(() {
                            MinhaSnackBar.mostrar(
                              Navigator.of(context).context,
                              texto: 'Aula apagada com sucesso!',
                            );
                          });
                        }
                      } catch (e) {
                        if (context.mounted) {
                          MinhaSnackBar.mostrar(
                            context,
                            texto: e.toString().contains('aula')
                                ? 'Não é possível apagar a aula.'
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
