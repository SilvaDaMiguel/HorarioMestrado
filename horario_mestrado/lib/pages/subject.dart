import 'package:flutter/material.dart';
// COMPONENTS
import '../components/navigation_bar.dart';
// VARIABLES
import '../variables/colors.dart';
// DATABASE
import '../database/database_service.dart';
// MODELS
import '../models/cadeira.dart';

class CadeirasPage extends StatefulWidget {
  const CadeirasPage({super.key});

  @override
  State<CadeirasPage> createState() => _CadeirasPageState();
}

class _CadeirasPageState extends State<CadeirasPage> {
  final DataBaseService _dbService = DataBaseService();
  late Future<List<Cadeira>> _cadeirasFuture;

  @override
  void initState() {
    super.initState();
    _cadeirasFuture = _dbService.obterCadeiras();
  }

  @override
  Widget build(BuildContext context) {
    //RESPONSIVIDADE
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    double altura = tamanho.height;

    //TEXTO
    double tamanhoTexto = comprimento * 0.04;
    double tamanhoTitulo = comprimento * 0.05;
    double tamanhoSubTexto = tamanhoTexto * 0.8;

    //PADDING
    double paddingAltura = altura * 0.075;
    double paddingComprimento = comprimento * 0.06;

    //OUTROS
    double tamanhoIcon = comprimento * 0.05;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Cadeiras'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Cadeira>>(
        future: _cadeirasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Cadeiras não encontradas'));
          }

          final cadeiras = snapshot.data!;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: paddingAltura,
              horizontal: paddingComprimento,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: cadeiras.length,
                  itemBuilder: (context, index) {
                    final cadeira = cadeiras[index];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cadeira.nome, // exemplo: nome da cadeira
                          style: TextStyle(
                            fontSize: tamanhoTitulo,
                            fontWeight: FontWeight.bold,
                            color: corPrimaria,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (cadeira.professores != null)
                          ...cadeira.professores!.map(
                            (professor) => Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.person, size: tamanhoIcon),
                                const SizedBox(width: 4),
                                Text(
                                  professor,
                                  style: TextStyle(
                                    fontSize: tamanhoSubTexto,
                                    color: corTexto,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/subjectInfo',
                                arguments: cadeira, // objeto Horario
                              );
                            },
                            child: Text('Ver mais')),
                        const Divider(),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: MyNavigationBar(IconSelecionado: 1),
    );
  }
}
