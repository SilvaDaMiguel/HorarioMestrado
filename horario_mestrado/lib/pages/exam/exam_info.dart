import 'package:flutter/material.dart';
// DATABASE
import '../../database/database_service.dart';
// MODELS
import '../../models/prova.dart';
import '../../models/cadeira.dart';
// VARIABLES
import '../../variables/colors.dart';
import '../../variables/icons.dart';
import '../../variables/size.dart';
// COMPONENTS
import '../../components/round_icon_button.dart';
import '../../components/structure/app_bar.dart';
import '../../components/structure/snack_bar.dart';
import '../../components/info_box.dart';

class ProvaInformacao extends StatefulWidget {
  final int provaID;
  const ProvaInformacao({super.key, required this.provaID});

  @override
  State<ProvaInformacao> createState() => _ProvaInformacaoState();
}

class _ProvaInformacaoState extends State<ProvaInformacao> {
  final DataBaseService _dbService = DataBaseService();
  late Future<Prova> _provaFuture;
  Cadeira? _cadeira;

  @override
  void initState() {
    super.initState();
    _provaFuture = _carregarProva();
  }

  Future<Prova> _carregarProva() async {
    final prova = await _dbService.obterProvaPorId(widget.provaID);
    _cadeira = await _dbService.obterCadeiraPorId(prova.cadeiraID);
    return prova;
  }

  @override
  Widget build(BuildContext context) {
    final tamanho = MediaQuery.of(context).size;
    final comprimento = tamanho.width;
    final altura = tamanho.height;

    return FutureBuilder<Prova>(
      future: _provaFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Erro ao carregar dados da prova.'),
            ),
          );
        } else if (!snapshot.hasData || _cadeira == null) {
          return const Scaffold(
            body: Center(child: Text('Prova não encontrada.')),
          );
        }

        final prova = snapshot.data!;
        final cadeira = _cadeira!;

        return Scaffold(
          appBar: MinhaAppBar(
            nome: 'Informação da Prova',
            icon: iconEditar,
            aoPressionar: () async {
              final provaAtualizada = await Navigator.pushNamed(
                context,
                '/examEdit',
                arguments: prova,
              );

              if (provaAtualizada is Prova) {
                setState(() {
                  _provaFuture = Future.value(provaAtualizada);
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
                  '${prova.tipo} ${cadeira.sigla} ${prova.data}',
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
                      '${prova.horaInicio} - ${prova.horaFim}',
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
                      prova.sala,
                      style: TextStyle(
                        fontSize: comprimento * tamanhoTexto,
                        color: corTexto,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: altura * distanciaItens),
                if (prova.concluido)
                  Text(
                    'Prova Concluída',
                    style: TextStyle(
                      color: corTexto,
                      fontSize: comprimento * tamanhoTexto,
                    ),
                  ),
                if (prova.concluido)
                  Text(
                    prova.nota != null
                        ? 'Nota: ${prova.nota} Valores'
                        : 'Nota: A aguardar',
                    style: TextStyle(
                      color: corTexto,
                      fontSize: comprimento * tamanhoTexto,
                    ),
                  ),
                SizedBox(height: altura * distanciaTemas),
                //INFORMAÇÕES
                Text(
                  'Informações da Prova:',
                  style: TextStyle(
                    fontSize: comprimento * tamanhoTexto,
                    color: corTexto,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: altura * distanciaItens),

                InfoBox(informacao: prova.informacao),

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
                        await _dbService.apagarProva(prova.provaID);

                        if (context.mounted) {
                          Navigator.pop(context, true); //Devolve true
                          Future.microtask(() {
                            MinhaSnackBar.mostrar(
                              Navigator.of(context).context,
                              texto: 'Prova apagada com sucesso!',
                            );
                          });
                        }
                      } catch (e) {
                        if (context.mounted) {
                          MinhaSnackBar.mostrar(
                            context,
                            texto: e.toString().contains('prova')
                                ? 'Não é possível apagar a prova porque esta já foi concluída.'
                                : 'Ocorreu um erro ao apagar a prova.',
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
