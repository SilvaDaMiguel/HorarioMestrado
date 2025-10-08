import 'package:flutter/material.dart';
//DATABASE
import '../database/database_service.dart';
//MODELS
import '../models/cadeira.dart';
//VARIABLES
import '../variables/colors.dart';
import '../variables/icons.dart';
//COMPONENTS
import '../components/navigation_bar.dart';
import '../components/info_box.dart';

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

    //TEXTO
    double tamanhoTexto = comprimento * 0.04;
    double tamanhoTitulo = comprimento * 0.05;
    double tamanhoSubTexto = tamanhoTexto * 0.8;

    //ESPAÇAMENTO
    double espacoTextoTitulo = altura * 0.01;
    double espacoTemas = altura * 0.035;

    //PADDING
    double paddingAltura = altura * 0.075;
    double paddingComprimento = comprimento * 0.06;

    //OUTROS
    double tamanhoIcon = comprimento * 0.05;

    return Scaffold(
      body: FutureBuilder<Cadeira>(
        future: _cadeiraFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar dados da cadeira.'),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text('Cadeira não encontrada.'),
            );
          }

          Cadeira cadeira = snapshot.data!;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: paddingAltura,
              horizontal: paddingComprimento,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TÍTULO
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${cadeira.sigla} - ${cadeira.nome}',
                        style: TextStyle(
                          fontSize: tamanhoTitulo,
                          fontWeight: FontWeight.bold,
                          color: corTexto,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: corTerciaria, size: tamanhoIcon),
                      onPressed: () async {
                        final result = await Navigator.pushNamed(
                          context,
                          '/subjectEdit',
                          arguments: cadeira,
                        );
                        if (result != null) {
                          setState(() {
                            _cadeiraFuture = Future.value(result as Cadeira);
                          });
                        }
                      },
                    )
                  ],
                ),
                SizedBox(height: espacoTemas),

                // PROFESSORES
                Text(
                  "Professores da Cadeira:",
                  style: TextStyle(
                    fontSize: tamanhoTexto,
                    color: corTexto,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: espacoTextoTitulo),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: cadeira.professores?.length ?? 0,
                  itemBuilder: (context, index) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          iconProfessor,
                          size: tamanhoIcon,
                          color: corTerciaria,
                        ),
                        SizedBox(width: 8),
                        Text(
                          cadeira.professores![index],
                          style: TextStyle(
                            fontSize: tamanhoSubTexto,
                            color: corTexto,
                          ),
                        ),
                      ],
                    );
                  },
                ),

                SizedBox(height: espacoTemas),

                // CONTEÚDOS
                Text(
                  'Conteúdos da Cadeira:',
                  style: TextStyle(
                    fontSize: tamanhoTexto,
                    color: corTexto,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: espacoTextoTitulo),
                InfoBox(informacao: cadeira.informacao),

                SizedBox(height: espacoTemas),

                // OUTRAS INFORMAÇÕES
                Text(
                  'Outras Informações:',
                  style: TextStyle(
                    fontSize: tamanhoTitulo,
                    color: corTexto,
                  ),
                ),
                SizedBox(height: espacoTextoTitulo),
                Text(
                  '${cadeira.ano}º Ano ${cadeira.semestre}º Semestre',
                  style: TextStyle(
                    color: corTexto,
                    fontSize: tamanhoTexto,
                  ),
                ),
                Text(
                  '${cadeira.creditos} ECTS',
                  style: TextStyle(
                    fontSize: tamanhoTexto,
                    color: corTexto,
                  ),
                ),
                if (cadeira.concluida)
                  Text(
                    'Cadeira Concluída',
                    style: TextStyle(
                      color: corTexto,
                      fontSize: tamanhoTexto,
                    ),
                  ),
                if (cadeira.concluida)
                  cadeira.nota != null
                      ? Text(
                          'Nota: ${cadeira.nota} Valores',
                          style: TextStyle(
                            color: corTexto,
                            fontSize: tamanhoTexto,
                          ),
                        )
                      : Text(
                          'Nota: A aguardar',
                          style: TextStyle(
                            color: corTexto,
                            fontSize: tamanhoTexto,
                          ),
                        ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: MyNavigationBar(mostrarSelecionado: false, IconSelecionado: 1),
    );
  }
}
