//RESPONSÁVEL PELAS OPERAÇÕES CRUD

import '../models/periodo.dart';
import '../models/cadeira.dart';
import '../models/horario.dart';
import 'database.dart';

class DataBaseService {
  final DatabaseProvider _dbProvider = DatabaseProvider();

  //Horario
  Future<int> inserirHorario(Horario horario) async {
    final db = await _dbProvider.database;
    return await db.insert('Horario', horario.toMap());
  }

  Future<List<Horario>> obterHorarios() async {
    final db = await _dbProvider.database;
    final result = await db.query('Horario');
    return result.map((e) => Horario.fromMap(e)).toList();
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