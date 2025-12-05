import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path/path.dart';
//PAGES
import 'pages/class/class_info.dart';
import 'pages/calendar.dart';
import 'pages/subject/subjects.dart';
import 'pages/subject/subject_info.dart';
import 'pages/subject/subject_edit.dart';
import 'pages/subject/subject_add.dart';
import 'pages/class/classes.dart';
import 'pages/class/class_add.dart';
import 'pages/class/class_edit.dart';
import 'pages/period/periods.dart';
import 'pages/period/period_info.dart';
import 'pages/period/period_edit.dart';
import 'pages/period/period_add.dart';
import 'pages/exam/exams.dart';
import 'pages/exam/exam_add.dart';
import 'pages/error.dart';
//MODELS
import 'models/aula.dart';
import 'models/cadeira.dart';
import 'models/periodo.dart';
//VARIABLES
import 'variables/colors.dart';
import 'variables/enums.dart';
//DATABASE
import 'database/storage_json.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Inicializa os ficheiros JSON necessários
  await JsonStorage.initJsonFile('${Ficheiros.cadeiras.nomeFicheiro}.json');
  await JsonStorage.initJsonFile('${Ficheiros.periodos.nomeFicheiro}.json');
  await JsonStorage.initJsonFile('${Ficheiros.aulas.nomeFicheiro}.json');
  await JsonStorage.initJsonFile('${Ficheiros.provas.nomeFicheiro}.json');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        '/subjects': (context) => const CadeirasPage(),
        '/subjectInfo': (context) {
          //Usa argumento
          final args = ModalRoute.of(context)!.settings.arguments as int;
          return CadeiraInformacao(
            cadeiraID: args,
          ); //Passa o ID da Cadeira como argumento
        },
        '/subjectEdit': (context) {
          //Usa argumento
          final args = ModalRoute.of(context)!.settings.arguments as Cadeira;
          return CadeiraEditar(cadeira: args); //Passa a Cadeira como argumento
        },
        '/subjectAdd': (context) => const CadeiraAdicionar(),
        '/classes': (context) => const AulasPage(),
        '/classInfo': (context) {
          //usando uma rota nomeada com parâmetros/argumentos
          final args = ModalRoute.of(context)!.settings.arguments as int;
          return AulaInformacao(
            aulaID: args,
          ); // Passa os argumentos para a página
        },
        '/classEdit': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Aula;
          return AulaEditar(aula: args);
        },
        '/classAdd': (context) => const AulaAdicionar(),
        '/periods': (context) => const PeriodosPage(),
        '/periodInfo': (context) {
          //Usa argumento
          final args = ModalRoute.of(context)!.settings.arguments as int;
          return PeriodoInformacao(
            periodoID: args,
          ); //Passa o ID do Periodo como argumento
        },
        '/periodEdit': (context) {
          //Usa argumento
          final args = ModalRoute.of(context)!.settings.arguments as Periodo;
          return PeriodoEditar(periodo: args); //Passa o Periodo como argumento
        },
        '/periodAdd': (context) => const PeriodoAdicionar(),
        '/exams': (context) => const ProvasPage(),
        '/examAdd': (context) => const ProvaAdicionar(),
        '/error': (context) => const ErrorPage(),
      },
      locale: Locale('pt', 'PT'), //Define o idioma para o calendário
      supportedLocales: [Locale('pt', 'PT')], //Suporte para o idioma português
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
