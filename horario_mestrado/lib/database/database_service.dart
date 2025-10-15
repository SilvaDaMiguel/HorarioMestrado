//RESPONSÁVEL PELAS OPERAÇÕES CRUD
import 'database.dart';
import 'storage_json.dart';
//MODELS
import '../models/periodo.dart';
import '../models/cadeira.dart';
import '../models/aula.dart';
//VARIABLES
import '../variables/enums.dart';

class DataBaseService {
  final DatabaseProvider _dbProvider = DatabaseProvider();

  //PERIODOS
  Future<Periodo> obterPeriodoPorId(int id) async {
    final db = await _dbProvider.database;
    return await db.transaction((txn) async {
      final result = await txn.query(
        'Periodo',
        where: 'periodoID = ?',
        whereArgs: [id],
      );
      if (result.isNotEmpty) {
        return Periodo.fromMap(result.first);
      } else {
        throw Exception('Período com ID $id não encontrado');
      }
    });
  }

  Future<List<Periodo>> obterPeriodos() async {
    final db = await _dbProvider.database;
    final result = await db.query('Periodo');
    return result.map((e) => Periodo.fromMap(e)).toList();
  }

  Future<int> atualizarPeriodo(Periodo periodo) async {
    final db = await _dbProvider.database;
    return await db.update(
      'Periodo',
      periodo.toMap(),
      where: 'periodoID = ?',
      whereArgs: [periodo.periodoID],
    );
  }

  //Verifica se o Período está associado a alguma Aula
  Future<bool> verificarPeriodoUtilizadoPorID(int id) async {
    final db = await _dbProvider.database;
    final result =
        await db.query('Aula', where: 'periodoID = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return true;
    } else {
      throw false;
    }
  }

  //CADEIRAS
  Future<Cadeira> obterCadeiraPorId(int id) async {
    final db = await _dbProvider.database;
    return await db.transaction((txn) async {
      final result = await txn.query(
        'Cadeira',
        where: 'cadeiraID = ?',
        whereArgs: [id],
      );
      if (result.isNotEmpty) {
        return Cadeira.fromMap(result.first);
      } else {
        throw Exception('Cadeira com ID $id não encontrada');
      }
    });
  }

  Future<List<Cadeira>> obterCadeiras() async {
    final db = await _dbProvider.database;
    final result = await db.query('Cadeira');
    return result.map((e) => Cadeira.fromMap(e)).toList();
  }

  //TODO: Criar ID automático => Talvez verificar o ultimo ID e somar 1
  Future<int> inserirCadeira(Cadeira cadeira) async {
    final db = await _dbProvider.database;
    final id = await db.insert('Cadeira', cadeira.toMap());

    //Adiciona o novo item ao JSON LOCAL
    await JsonCrud.adicionarDadoJSON(
        '${ficheiros.cadeiras}.json', cadeira.toMap());

    return id;
  }

  //TODO: Repetir processo de JSON LOCAL em todos os métodos CRUD necessários
  Future<int> atualizarCadeira(Cadeira cadeira) async {
    final db = await _dbProvider.database;

    //Atualiza a BD
    final linhasAfetadas = await db.update(
      'Cadeira',
      cadeira.toMap(),
      where: 'cadeiraID = ?',
      whereArgs: [cadeira.cadeiraID],
    );

    //Se a atualização na BD for bem sucedida, atualiza o JSON LOCAL
    if (linhasAfetadas > 0) {
      await JsonCrud.atualizarDadoJSON(
          '${ficheiros.cadeiras}.json', cadeira.cadeiraID, cadeira.toMap());
    }

    return linhasAfetadas;
  }

  //Verifica se a Cadeira está associada a alguma Aula
  Future<bool> verificarCadeiraUtilizadoPorID(int id) async {
    final db = await _dbProvider.database;
    final result =
        await db.query('Aula', where: 'cadeiraID = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return true;
    } else {
      throw false;
    }
  }

  //HORARIO
  Future<Aula> obterAulaPorId(int id) async {
    final db = await _dbProvider.database;
    final result = await db.query('Aula', where: 'aulaID = ?', whereArgs: [id]);
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
      where: 'aulaID = ?',
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
