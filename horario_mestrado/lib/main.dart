import 'package:flutter/material.dart';
//PAGES
import 'pages/class_info.dart';
import 'pages/calendar.dart';
//MODELS
import 'models/horario.dart';
import 'models/cadeira.dart';
import 'models/periodo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Horário Mestrado',
      routes: {
        '/': (context) => const CalendarioPage( ),
        '/calendar': (context) => const CalendarioPage(),
        '/classInfo': (context) { //usando uma rota nomeada com parâmetros/argumentos
          final args = ModalRoute.of(context)!.settings.arguments as Horario;
          return AulaInformacao(horario: args); // Passa os argumentos para a página
        },
      },
    );
  }
}
