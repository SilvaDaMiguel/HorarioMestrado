import 'package:flutter/material.dart';

class PaginaInicial extends StatelessWidget {
  const PaginaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    //TAMANHO PARA RESPONSIVIDADE
    //var tamanho = MediaQuery.of(context).size;
    //double comprimento = tamanho.width;
    //double altura = tamanho.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Página Inicial'),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            Text("Texto"),
          ],
        ),
      )
    );
  }
}