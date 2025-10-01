// database.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'database_seeder.dart';

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
      version: 1, //Incrementa se mudar a versão da base de dados
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Periodo (
        periodoID INTEGER PRIMARY KEY,
        diaSemana TEXT,
        horaInicio TEXT,
        horaFim TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Cadeira (
        cadeiraID INTEGER PRIMARY KEY,
        nome TEXT,
        sigla TEXT,
        ano INTEGER,
        semestre INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE Horario (
        horarioID INTEGER PRIMARY KEY,
        cadeiraID INTEGER,
        periodoID INTEGER,
        ano INTEGER,
        semestre INTEGER,
        sala TEXT,
        data TEXT,
        FOREIGN KEY (periodoID) REFERENCES Periodo(periodoID),
        FOREIGN KEY (cadeiraID) REFERENCES Cadeira(cadeiraID)
      )
    ''');

    //Adiciona os dados à base de dados com os JSON
    final seeder = DatabaseSeeder(db);
    await seeder.seedDatabase();
  }

  //Apagar a base de dados (usado para reset)
  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'mestrado_horario.db');
    await deleteDatabase(path);
    _database = null;
  }
}
