//Carregar JSONs
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';

class DatabaseSeeder {
  final Database db;

  DatabaseSeeder(this.db);

  Future<void> seedDatabase() async {
    //Carregar JSONs da pasta assets/json
    final periodosJson = await rootBundle.loadString('assets/json/periodos.json');
    final cadeirasJson = await rootBundle.loadString('assets/json/cadeiras.json');
    final horarioJson = await rootBundle.loadString('assets/json/horario.json');

    final periodos = jsonDecode(periodosJson) as List;
    final cadeiras = jsonDecode(cadeirasJson) as List;
    final horarios = jsonDecode(horarioJson) as List;

    //Inserir Periodos
    for (var p in periodos) {
      await db.insert("Periodo", {
        "periodoID": p["id"],
        "diaSemana": p["diaSemana"],
        "horaInicio": p["horaInicial"],
        "horaFim": p["horaFinal"],
      }, conflictAlgorithm: ConflictAlgorithm.replace); //Grava por cima caso exista algum conflito
    }

    //Inserir Cadeiras
    for (var c in cadeiras) {
      await db.insert("Cadeira", {
        "cadeiraID": c["id"],
        "nome": c["nome"],
        "sigla": c["sigla"],
        "ano": c["ano"],
        "semestre": c["semestre"],
        "informacao": c["informacao"] ?? "Sem Informação",
      }, conflictAlgorithm: ConflictAlgorithm.replace); //Grava por cima caso exista algum conflito
    }

    //Inserir Horário
    for (var h in horarios) {
      await db.insert("Horario", {
        "horarioID": h["id"],
        "cadeiraID": h["cadeiraId"],
        "periodoID": h["periodoId"],
        "ano": h["ano"],
        "semestre": h["semestre"],
        "sala": h["sala"],
        "data": h["data"],
      }, conflictAlgorithm: ConflictAlgorithm.replace); //Grava por cima casoo exista algum conflito
    }
  }
}
