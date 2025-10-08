import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path/path.dart';
//PAGES
import 'pages/class_info.dart';
import 'pages/calendar.dart';
import 'pages/subjects.dart';
import 'pages/subject_info.dart';
import 'pages/subject_edit.dart';
import 'pages/classes.dart';
import 'pages/error.dart';
//MODELS
import 'models/aula.dart';
import 'models/cadeira.dart';
import 'models/periodo.dart';
//VARIABLES
import 'variables/colors.dart';

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
      theme: ThemeData(
        scaffoldBackgroundColor:
            corPrimaria, // muda o fundo padrão de todas as páginas
      ),
      routes: {
        '/': (context) => const CalendarioPage(),
        '/calendar': (context) => const CalendarioPage(),
        '/classInfo': (context) {
          //usando uma rota nomeada com parâmetros/argumentos
          final args = ModalRoute.of(context)!.settings.arguments as Aula;
          return AulaInformacao(
              aula: args); // Passa os argumentos para a página
        },
        '/subjects': (context) => const CadeirasPage(),
        '/subjectInfo': (context) {
          //Usa argumento
          final args = ModalRoute.of(context)!.settings.arguments as int;
          return CadeiraInformacao(
              cadeiraID: args); //Passa a Cadeira como argumento
        },
        '/subjectEdit': (context) {
          //Usa argumento
          final args = ModalRoute.of(context)!.settings.arguments as Cadeira;
          return CadeiraEditar(cadeira: args); //Passa a Cadeira como argumento
        },
        '/classes': (context) => const AulasPage(),
        '/error': (context) => const ErrorPage(),
      },
      locale: Locale('pt', 'BR'), // Define o idioma para o calendário
      supportedLocales: [Locale('pt', 'BR')], // Suporte para o idioma português
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
