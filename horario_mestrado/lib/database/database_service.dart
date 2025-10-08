//RESPONSÁVEL PELAS OPERAÇÕES CRUD

import '../models/periodo.dart';
import '../models/cadeira.dart';
import '../models/aula.dart';
import 'database.dart';

class DataBaseService {
  final DatabaseProvider _dbProvider = DatabaseProvider();

  //PERIODOS
  Future<Periodo> obterPeriodoPorId(int id) async {
    final db = await _dbProvider.database;
    final result =
        await db.query('Periodo', where: 'periodoID = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Periodo.fromMap(result.first);
    } else {
      throw Exception('Período com ID $id não encontrado');
    }
  }

  //CADEIRAS
  //TODO: Fazer pesquisa por ID em vez de enviar objeto => Melhor para atualizar os dados
  Future<Cadeira> obterCadeiraPorId(int id) async {
    final db = await _dbProvider.database;
    final result =
        await db.query('Cadeira', where: 'cadeiraID = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Cadeira.fromMap(result.first);
    } else {
      throw Exception('Cadeira com ID $id não encontrada');
    }
  }

  Future<List<Cadeira>> obterCadeiras() async {
    final db = await _dbProvider.database;
    final result = await db.query('Cadeira');
    return result.map((e) => Cadeira.fromMap(e)).toList();
  }

  Future<int> atualizarCadeira(Cadeira cadeira) async{
    final db = await _dbProvider.database;
    return await db.update(
      'Cadeira',
      cadeira.toMap(),
      where: 'cadeiraID = ?',
      whereArgs: [cadeira.cadeiraID],
    );
  }

  //HORARIO
  Future<Aula> obterAulaPorId(int id) async {
    final db = await _dbProvider.database;
    final result =
        await db.query('Aula', where: 'aulaID = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Aula.fromMap(result.first);
    } else {
      throw Exception('Horário com ID $id não encontrado');
    }
  }

  Future<List<Aula>> obterAulas() async {
    final db = await _dbProvider.database;
    final result = await db.query('Aula');
    return result.map((e) => Aula.fromMap(e)).toList();
  }

  Future<int> inserirAula(Aula aula) async {
    final db = await _dbProvider.database;
    return await db.insert('Aula', aula.toMap());
  }

  Future<int> atualizarAula(Aula aula) async {
    final db = await _dbProvider.database;
    return await db.update(
      'Aula',
      aula.toMap(),
      where: 'id = ?',
      whereArgs: [aula.aulaID],
    );
  }

  Future<int> apagarAula(int id) async {
    final db = await _dbProvider.database;
    return await db.delete('Aula', where: 'aulaID = ?', whereArgs: [id]);
  }

  //RESET => PERIGO
  Future<void> resetBaseDeDados() async {
    await _dbProvider.deleteDatabaseFile();
  }
}
