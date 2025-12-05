//Carregar JSONs
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';
//DATABASE
import 'storage_json.dart';
//VARIABLES
import '../variables/enums.dart';

class DatabaseSeeder {
  final Database db;

  DatabaseSeeder(this.db);

  Future<void> seedDatabase() async {
    //Carregar JSONs da pasta local
    final filePeriodos = await JsonStorage.getLocalJsonFile(
      '${Ficheiros.periodos.nomeFicheiro}.json',
    );
    final periodosJson = await filePeriodos.readAsString();

    final fileCadeiras = await JsonStorage.getLocalJsonFile(
      '${Ficheiros.cadeiras.nomeFicheiro}.json',
    );
    final cadeirasJson = await fileCadeiras.readAsString();

    final fileAulas = await JsonStorage.getLocalJsonFile(
      '${Ficheiros.aulas.nomeFicheiro}.json',
    );
    final aulasJson = await fileAulas.readAsString();

    final fileProvas = await JsonStorage.getLocalJsonFile(
      '${Ficheiros.provas.nomeFicheiro}.json',
    );
    final provasJson = await fileProvas.readAsString();

    final periodos = jsonDecode(periodosJson) as List;
    final cadeiras = jsonDecode(cadeirasJson) as List;
    final aulas = jsonDecode(aulasJson) as List;
    final provas = jsonDecode(provasJson) as List;

    //Inserir Periodos
    for (var p in periodos) {
      await db.insert(
        "Periodo",
        {
          "periodoID": p["id"],
          "diaSemana": p["diaSemana"],
          "horaInicio": p["horaInicial"],
          "horaFim": p["horaFinal"],
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      ); //Grava por cima caso exista algum conflito
    }

    //Inserir Cadeiras
    for (var c in cadeiras) {
      await db.insert(
        "Cadeira",
        {
          "cadeiraID": c["id"],
          "nome": c["nome"],
          "sigla": c["sigla"],
          "ano": c["ano"],
          "semestre": c["semestre"],
          "informacao": c["informacao"] ?? "Sem Informação",
          "professores": jsonEncode(
            c["professores"] ?? [],
          ), //Salvar como string JSON
          "creditos": c["creditos"] ?? 0,
          "concluida": c["concluida"] ?? 0,
          "nota": c["nota"],
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      ); //Grava por cima caso exista algum conflito
    }

    //Inserir Horário
    for (var a in aulas) {
      await db.insert(
        "Aula",
        {
          "aulaID": a["id"],
          "cadeiraID": a["cadeiraId"],
          "periodoID": a["periodoId"],
          "sala": a["sala"],
          "data": a["data"],
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      ); //Grava por cima casoo exista algum conflito
    }

    //Inserir Provas
    for (var p in provas) {
      await db.insert(
        "Prova",
        {
          "provaID": p["id"],
          "cadeiraID": p["cadeiraId"],
          "sala": p["sala"] ?? "?",
          "data": p["data"],
          "horaInicio": p["horaInicial"],
          "horaFim": p["horaFinal"],
          "tipo": p["tipo"],
          "epoca": p["epoca"],
          "informacao": p["informacao"] ?? "Sem Informação",
          "nota": p["nota"],
          "concluido": p["concluido"] ?? 0, //Bool, default é False
        },
        conflictAlgorithm: ConflictAlgorithm
            .replace, //Grava por cima caso exista algum conflito
      );
    }
  }
}
