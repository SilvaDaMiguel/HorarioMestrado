import 'package:flutter/material.dart';
//DATABASE
import '../../database/database_service.dart';
//MODELS
import '../../models/periodo.dart';
//VARIABLES
import '../../variables/colors.dart';
import '../../variables/icons.dart';
import '../../variables/size.dart';
//COMPONENTS
import '../../components/structure/navigation_bar.dart';
import '../../components/structure/app_bar.dart';
import '../../components/structure/snack_bar.dart';
import '../../components/round_icon_button.dart';

class PeriodoInformacao extends StatefulWidget {
  final int periodoID;
  const PeriodoInformacao({super.key, required this.periodoID});

  @override
  _PeriodoInformacaoState createState() => _PeriodoInformacaoState();
}

class _PeriodoInformacaoState extends State<PeriodoInformacao> {
  final DataBaseService _dbService = DataBaseService();
  late Future<Periodo> _periodoFuture;

  @override
  void initState() {
    super.initState();
    _periodoFuture = _dbService.obterPeriodoPorId(widget.periodoID);
  }

  @override
  Widget build(BuildContext context) {
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    double altura = tamanho.height;

    return FutureBuilder<Periodo>(
      future: _periodoFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Erro ao carregar dados do período.')),
          );
        } else if (!snapshot.hasData) {
          return Scaffold(body: Center(child: Text('Período não encontrado.')));
        }

        //Dados carregados
        Periodo periodo = snapshot.data!;

        return Scaffold(
          appBar: MinhaAppBar(
            nome: 'Informação do Período',
            icon: iconEditar,
            //rota: '/periodEdit',
            //argumento: periodo, //Passa o objeto completo
            aoPressionar: () async {
              final periodoAtualizado = await Navigator.pushNamed(
                context,
                '/periodEdit',
                arguments: periodo,
              );

              //Se a página de adicionar devolver true => Adicionado/Removido um Período
              if (periodoAtualizado is Periodo) {
                setState(() {
                  _periodoFuture = Future.value(periodoAtualizado);
                });
              }
            },
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: altura * paddingAltura,
              horizontal: comprimento *paddingComprimento,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // DIA
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        periodo.diaSemana,
                        style: TextStyle(
                          fontSize: comprimento * tamanhoTitulo,
                          fontWeight: FontWeight.bold,
                          color: corTexto,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: altura * distanciaItens),
                Text(
                  'Hora Inicial: ${periodo.horaInicio}',
                  style: TextStyle(
                    fontSize: comprimento * tamanhoTexto,
                    color: corTexto,
                  ),
                ),
                SizedBox(height: altura * distanciaItens),
                Text(
                  'Hora Final: ${periodo.horaFim}',
                  style: TextStyle(
                    fontSize: comprimento * tamanhoTexto,
                    color: corTexto,
                  ),
                ),
                SizedBox(height: altura * distanciaTemas),

                //BOTÃO APAGAR
                Center(
                  child: IconBotaoRedondo(
                    corIcon: Colors.red,
                    aoSelecionar: () async {
                      try {
                        //Tenta apagar o período
                        await _dbService.apagarPeriodo(periodo.periodoID);

                        // Se for bem-sucedido, volta à página dos períodos
                        if (context.mounted) {
                          Navigator.pop(
                            context,
                            true,
                          ); //Devolve True pois apagou 1 periodo
                          Future.microtask(() {
                            MinhaSnackBar.mostrar(
                              Navigator.of(context).context,
                              texto: 'Período apagado com sucesso!',
                            );
                          });
                        }
                      } catch (e) {
                        //Mostra o snack-bar de erro se algo falhar
                        if (context.mounted) {
                          MinhaSnackBar.mostrar(
                            context,
                            texto: e.toString().contains('período')
                                ? 'Não é possível apagar o período porque está associado a uma ou mais aulas.' //Para não aparecer o "Exception:"
                                : 'Ocorreu um erro ao apagar o período.',
                          );
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
