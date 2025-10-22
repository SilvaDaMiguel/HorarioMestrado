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

    //PADDING
    double paddingAltura = altura * 0.075;
    double paddingComprimento = comprimento * 0.06;

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

        // Dados carregados ✅
        Periodo periodo = snapshot.data!;

        return Scaffold(
          appBar: MinhaAppBar(
            nome: 'Informação do Período',
            icon: iconEditar,
            rota: '/periodEdit',
            argumento: periodo, //Passa o objeto completo
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: paddingAltura,
              horizontal: paddingComprimento,
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
                  'Início: ${periodo.horaInicio}',
                  style: TextStyle(fontSize: comprimento * tamanhoTexto),
                ),
                SizedBox(height: altura * distanciaItens),
                Text(
                  'Fim: ${periodo.horaFim}',
                  style: TextStyle(fontSize: comprimento * tamanhoTexto),
                ),
                SizedBox(height: altura * distanciaTemas),
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
