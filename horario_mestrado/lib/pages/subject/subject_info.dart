import 'package:flutter/material.dart';
//DATABASE
import '../../database/database_service.dart';
//MODELS
import '../../models/cadeira.dart';
//VARIABLES
import '../../variables/colors.dart';
import '../../variables/icons.dart';
import '../../variables/size.dart';
//COMPONENTS
import '../../components/structure/navigation_bar.dart';
import '../../components/structure/snack_bar.dart';
import '../../components/info_box.dart';
import '../../components/structure/app_bar.dart';
import '../../components/round_icon_button.dart';

class CadeiraInformacao extends StatefulWidget {
  final int cadeiraID;
  const CadeiraInformacao({super.key, required this.cadeiraID});

  @override
  _CadeiraInformacaoState createState() => _CadeiraInformacaoState();
}

class _CadeiraInformacaoState extends State<CadeiraInformacao> {
  final DataBaseService _dbService = DataBaseService();
  late Future<Cadeira> _cadeiraFuture;

  @override
  void initState() {
    super.initState();
    _cadeiraFuture = _dbService.obterCadeiraPorId(widget.cadeiraID);
  }

  @override
  Widget build(BuildContext context) {
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    double altura = tamanho.height;

    return FutureBuilder<Cadeira>(
      future: _cadeiraFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Erro ao carregar dados da cadeira.')),
          );
        } else if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: Text('Cadeira não encontrada.')),
          );
        }

        // DADOS CARREGADOS
        final cadeira = snapshot.data!;

        return Scaffold(
          appBar: MinhaAppBar(
            nome: 'Informação da Cadeira',
            icon: iconEditar,
            rota: '/subjectEdit',
            argumento: cadeira, //Passa o objeto completo
          ),
          //TODO: atualizar a pagina depois de editar
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
                  '${cadeira.sigla} - ${cadeira.nome}',
                  style: TextStyle(
                    fontSize: comprimento * tamanhoTitulo,
                    fontWeight: FontWeight.bold,
                    color: corTexto,
                  ),
                ),
                SizedBox(height: altura * distanciaTemas),

                //PROFESSORES
                Text(
                  "Professores da Cadeira:",
                  style: TextStyle(
                    fontSize: comprimento * tamanhoTexto,
                    color: corTexto,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: altura * distanciaItens),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: cadeira.professores?.length ?? 0,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Icon(
                          iconProfessor,
                          size: comprimento * tamanhoIcon,
                          color: corTerciaria,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          cadeira.professores![index],
                          style: TextStyle(
                            fontSize: comprimento * tamanhoSubTexto,
                            color: corTexto,
                          ),
                        ),
                      ],
                    );
                  },
                ),

                SizedBox(height: altura * distanciaTemas),

                //CONTEÚDOS
                Text(
                  'Conteúdos da Cadeira:',
                  style: TextStyle(
                    fontSize: comprimento * tamanhoTexto,
                    color: corTexto,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: altura * distanciaItens),
                InfoBox(informacao: cadeira.informacao),

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
                  '${cadeira.ano}º Ano ${cadeira.semestre}º Semestre',
                  style: TextStyle(
                    color: corTexto,
                    fontSize: comprimento * tamanhoTexto,
                  ),
                ),
                Text(
                  '${cadeira.creditos} ECTS',
                  style: TextStyle(
                    fontSize: comprimento * tamanhoTexto,
                    color: corTexto,
                  ),
                ),
                if (cadeira.concluida)
                  Text(
                    'Cadeira Concluída',
                    style: TextStyle(
                      color: corTexto,
                      fontSize: comprimento * tamanhoTexto,
                    ),
                  ),
                if (cadeira.concluida)
                  Text(
                    cadeira.nota != null
                        ? 'Nota: ${cadeira.nota} Valores'
                        : 'Nota: A aguardar',
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
                        //Tenta apagar a cadeira
                        await _dbService.apagarCadeira(cadeira.cadeiraID);

                        // Se for bem-sucedido, volta à página das cadeiras
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/subjects',
                            (route) => false,
                          );
                          Future.microtask(() {
                            MinhaSnackBar.mostrar(
                              Navigator.of(context).context,
                              texto: 'Cadeira apagada com sucesso!',
                            );
                          });
                        }
                      } catch (e) {
                        //Mostra o sncakbar de erro se algo falhar
                        if (context.mounted) {
                          if (context.mounted) {
                            MinhaSnackBar.mostrar(
                              context,
                              texto: e.toString().contains('aulas')
                                  ? 'Não é possível apagar a cadeira porque está associada a uma ou mais aulas.' //Para não aparecer o"Exception:"
                                  : 'Ocorreu um erro ao apagar a cadeira.',
                            );
                          }
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: MyNavigationBar(
            mostrarSelecionado: false,
            IconSelecionado: 1,
          ),
        );
      },
    );
  }
}
