import 'package:flutter/material.dart';
//COMPONENTS
import '../components/structure/navigation_bar.dart';
//VARIABLES
import '../variables/colors.dart';
import '../variables/size.dart';

class ErrorPage extends StatelessWidget {

  const ErrorPage({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    //RESPONSIVIDADE
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    double altura = tamanho.height * 0.1;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Alinha no centro da página verticalmente
              crossAxisAlignment: CrossAxisAlignment.center, // Alinha no centro da página horizontalmente
              children: [
                Text(
                'ERRO',
                style: TextStyle(
                  color: corTexto,
                  fontSize: comprimento * tamanhoTitulo,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: altura),
              Text(
                  'Alguma coisa correu mal na aplicação.',
                  style: TextStyle(
                    color: corTexto,
                    fontSize: comprimento * tamanhoTexto, // Ajuste relativo ao tamanho da tela
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: MyNavigationBar(mostrarSelecionado: false),
    );
  }
}