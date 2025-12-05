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
      version: 2, //Incrementar se mudar a versão da base de dados
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
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
        semestre INTEGER,
        informacao TEXT,
        professores TEXT,
        creditos INTEGER,
        concluida INTEGER,
        nota REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE Aula (
        aulaID INTEGER PRIMARY KEY,
        cadeiraID INTEGER,
        periodoID INTEGER,
        sala TEXT,
        data TEXT,
        FOREIGN KEY (periodoID) REFERENCES Periodo(periodoID),
        FOREIGN KEY (cadeiraID) REFERENCES Cadeira(cadeiraID)
      )
    ''');

    await _version2Upgrade(db);

    //Adiciona os dados à base de dados com os JSON
    final seeder = DatabaseSeeder(db);
    await seeder.seedDatabase();
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 2) {
    await _version2Upgrade(db);
  }
}

  Future<void> _version2Upgrade(Database db) async{
    //Código SQL para a nova tabela Prova
    await db.execute('''
      CREATE TABLE Prova (
        provaID INTEGER PRIMARY KEY,
        cadeiraID INTEGER,
        sala TEXT,
        data TEXT,
        horaInicio TEXT,
        horaFim TEXT,
        tipo TEXT,
        epoca TEXT,
        informacao TEXT,
        nota REAL,
        concluido INTEGER,
        FOREIGN KEY (cadeiraID) REFERENCES Cadeira(cadeiraID)
      )
    ''');
  }

  //Apagar a base de dados (usado para reset)
  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'mestrado_horario.db');
    await deleteDatabase(path);
    _database = null;
  }
}
