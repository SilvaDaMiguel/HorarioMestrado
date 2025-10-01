//RESPONSÁVEL APENAS POR INICIAR E CONFIGUAR A BASE DE DADOS

//import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  static final DatabaseProvider _instance = DatabaseProvider._internal();

  factory DatabaseProvider() => _instance;

  DatabaseProvider._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('mestrado_horario.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1, // Incrementar a versão se houver mudanças no esquema
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Periodo (
        periodoID INTEGER PRIMARY KEY AUTOINCREMENT,
        diaSemana INTEGER,
        horaInicio TEXT,
        horaFim TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Cadeira (
        cadeiraID INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        sigla TEXT,
        ano INTEGER,
        semestre INTEGER,
        FOREIGN KEY (pomodoroID) REFERENCES Pomodoro(pomodoroID)
      )
    ''');

    await db.execute('''
      CREATE TABLE Horario (
        horarioID INTEGER PRIMARY KEY,
        FOREIGN KEY (periodoID) REFERENCES Periodo(periodoID),
        FOREIGN KEY (cadeiraID) REFERENCES Cadeira(cadeiraID)
        ano INTEGER,
        semestre INTEGER
      )
    ''');

    await db.insert('Definicoes', {
      'id': 1,
      'nome': null,
      'idioma': 'pt',
      'modoEscuro': 0, //0 = false, 1 = true
      'protegido': 0, //0 = false, 1 = true
      'codigo': null,
      'contaCriada': 0, //0 = false, 1 = true
    });
  }

  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'mestrado_horario.db');
    await deleteDatabase(path);
    _database = null;
  }
}