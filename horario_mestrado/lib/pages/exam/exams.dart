import 'package:flutter/material.dart';
import 'package:horario_mestrado/variables/icons.dart';
// COMPONENTS
import '../../components/structure/navigation_bar.dart';
import '../../components/subject_box.dart';
import '../../components/structure/app_bar.dart';
// DATABASE
import '../../database/database_service.dart';
// MODELS
import '../../models/prova.dart';
//VARIABLES
import '../../variables/size.dart';
import '../../variables/enums.dart';
import '../../variables/colors.dart';

class ProvasPage extends StatefulWidget {
  const ProvasPage({super.key});

  @override
  State<ProvasPage> createState() => _ProvasPageState();
}

class _ProvasPageState extends State<ProvasPage> {
  final DataBaseService _dbService = DataBaseService();
  late Future<List<Prova>> _provasFuture;

  @override
  void initState() {
    super.initState();
    _carregarProvas();
  }

  void _carregarProvas() {
    setState(() {
      _provasFuture = _dbService.obterProvas();
    });
  }

  @override
  Widget build(BuildContext context) {
    //RESPONSIVIDADE
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    double altura = tamanho.height;

    return Scaffold(
      appBar: MinhaAppBar(
        nome: 'Lista de Provas',
        icon: iconAdicionar,
        aoPressionar: () async {
          final resultado = await Navigator.pushNamed(context, '/examAdd');

          //Se a página de adicionar devolver true => Adicionado/Removido uma prova
          if (resultado == true) {
            print("Prova adicionada ou Apagada!!!");
            _carregarProvas(); //Atualiza a lista
          }
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: altura * paddingAltura,
          horizontal: comprimento * paddingComprimento,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            //SizedBox(height: altura * distanciaTemas),
            //CONTEÚDO DINÂMICO (LISTA)
            Expanded(
              child: FutureBuilder<List<Prova>>(
                future: _provasFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Erro: ${snapshot.error}',
                        style: TextStyle(
                          color: corTexto,
                          fontSize: comprimento * tamanhoTexto,
                        ),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        'Não foram encontradas Provas',
                        style: TextStyle(
                          color: corTexto,
                          fontSize: comprimento * tamanhoTexto,
                        ),
                      ),
                    );
                  }

                  final provas = snapshot.data!;
                  return ListView.builder(
                    itemCount: provas.length,
                    itemBuilder: (context, index) {
                      final prova = provas[index];
                      return Text(
                        'Prova ID: ${prova.provaID}, Cadeira ID: ${prova.cadeiraID}, Data: ${prova.data}, Hora Início: ${prova.horaInicio}, Hora Fim: ${prova.horaFim}, Tipo: ${prova.tipo}, Época: ${prova.epoca}, Sala: ${prova.sala}, Informação: ${prova.informacao}, Nota: ${prova.nota ?? 'N/A'}, Concluído: ${prova.concluido ? 'Sim' : 'Não'}',
                        style: TextStyle(
                          color: corTexto,
                          fontSize: comprimento * tamanhoTexto,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MyNavigationBar(IconSelecionado: 4),
    );
  }
}
