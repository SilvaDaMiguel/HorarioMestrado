//RESPONSÁVEL PELAS OPERAÇÕES CRUD

import '../models/periodo.dart';
import '../models/cadeira.dart';
import '../models/horario.dart';
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
  Future<Horario> obterHorarioPorId(int id) async {
    final db = await _dbProvider.database;
    final result =
        await db.query('Horario', where: 'horarioID = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Horario.fromMap(result.first);
    } else {
      throw Exception('Horário com ID $id não encontrado');
    }
  }

  Future<List<Horario>> obterHorarios() async {
    final db = await _dbProvider.database;
    final result = await db.query('Horario');
    return result.map((e) => Horario.fromMap(e)).toList();
  }

  Future<int> inserirHorario(Horario horario) async {
    final db = await _dbProvider.database;
    return await db.insert('Horario', horario.toMap());
  }

  Future<int> atualizarHorario(Horario horario) async {
    final db = await _dbProvider.database;
    return await db.update(
      'Horario',
      horario.toMap(),
      where: 'id = ?',
      whereArgs: [horario.horarioID],
    );
  }

  Future<int> apagarHorario(int id) async {
    final db = await _dbProvider.database;
    return await db.delete('Horario', where: 'horarioID = ?', whereArgs: [id]);
  }

  //RESET => PERIGO
  Future<void> resetBaseDeDados() async {
    await _dbProvider.deleteDatabaseFile();
  }
}
