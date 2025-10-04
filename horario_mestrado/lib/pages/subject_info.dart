import 'package:flutter/material.dart';
import 'package:horario_mestrado/components/info_box.dart';
//DATABASE
import '../database/database_service.dart';
//MODELS
import '../models/cadeira.dart';
//VARIABLES
import '../variables/colors.dart';
import '../variables/icons.dart';

class CadeiraInformacao extends StatelessWidget {
  final Cadeira cadeira;
  const CadeiraInformacao({super.key, required this.cadeira});

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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: paddingAltura,
          horizontal: paddingComprimento,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${cadeira.sigla} - ${cadeira.nome}',
              style: TextStyle(
                fontSize: tamanhoTitulo,
                fontWeight: FontWeight.bold,
                color: corTexto,
              ),
            ),
            //TODO: Adicionar Icon Lapis ao lado do título para editar
            SizedBox(height: espacoTemas),
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
                    Text(
                      cadeira.professores![index],
                      style:
                          TextStyle(fontSize: tamanhoSubTexto, color: corTexto),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: espacoTemas),
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
      ),
    );
  }
}
