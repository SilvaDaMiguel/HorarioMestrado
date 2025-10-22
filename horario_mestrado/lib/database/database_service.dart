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

  Future<List<Periodo>> obterPeriodosFiltradosDiaSemana(
    List<String> filtro,
  ) async {
    final db = await _dbProvider.database;

    final result = await db.query(
      'Periodo',
      where: 'diaSemana = ?', //Condição WHERE
      whereArgs: filtro,
      orderBy:
          'diaSemana, horaInicio', //Ordenar por dia da semana e hora de início
    );

    return result.map((e) => Periodo.fromMap(e)).toList();
  }

  Future<int> atualizarPeriodo(Periodo periodo) async {
    final db = await _dbProvider.database;
    final linhasAfetadas = await db.update(
      'Periodo',
      periodo.toMap(),
      where: 'periodoID = ?',
      whereArgs: [periodo.periodoID],
    );

    //Se a atualização na BD for bem sucedida, atualiza o JSON LOCAL
    if (linhasAfetadas > 0) {
      await JsonCrud.atualizarDadoJSON(
        '${Ficheiros.periodos.nomeFicheiro}.json',
        periodo.periodoID,
        periodo.toMap(),
      );
    }

    return linhasAfetadas;
  }

  //Verifica se o Período está associado a alguma Aula
  Future<bool> verificarPeriodoUtilizadoPorID(int id) async {
    final db = await _dbProvider.database;
    final result = await db.query(
      'Aula',
      where: 'periodoID = ?',
      whereArgs: [id],
    );
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

  //Obter Cadeiras com filtro (ano, semestre)
  Future<List<Cadeira>> obterCadeirasFiltradas(List<int> filtro) async {
    final db = await _dbProvider.database;

    final result = await db.query(
      'Cadeira',
      where:
          'ano = ? AND semestre = ?', //Condição WHERE (ex: "ano = 1 AND semestre = 2")
      whereArgs: filtro,
      orderBy: 'semestre, ano', //Ordenar por semestre e ano
    );

    return result.map((e) => Cadeira.fromMap(e)).toList();
  }

  Future<int> obterNovoIDCadeira() async {
    final db = await _dbProvider.database;
    final result = await db.rawQuery(
      'SELECT MAX(cadeiraID) as maxId FROM Cadeira',
    );
    final maxId = result.first['maxId'] as int?;
    return (maxId ?? 0) + 1;
  }

  Future<int> adicionarCadeira(Cadeira cadeira) async {
    final db = await _dbProvider.database;
    final id = await db.insert('Cadeira', cadeira.toMap());

    //Adiciona o novo item ao JSON LOCAL
    await JsonCrud.adicionarDadoJSON(
      '${Ficheiros.cadeiras.nomeFicheiro}.json',
      cadeira.toMap(),
    );

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
        '${Ficheiros.cadeiras.nomeFicheiro}.json',
        cadeira.cadeiraID,
        cadeira.toMap(),
      );
    }

    return linhasAfetadas;
  }

  Future<int> apagarCadeira(int id) async {
    final db = await _dbProvider.database;

    //Apaga da BD
    final linhasAfetadas =
        await db.delete('Cadeira', where: 'cadeiraID = ?', whereArgs: [id]);

    //Se a remoção na BD for bem sucedida, remove do JSON LOCAL
    if (linhasAfetadas > 0) {
      await JsonCrud.apagarDadoJSON(
        '${Ficheiros.cadeiras.nomeFicheiro}.json',
        id,
      );
    }

    return linhasAfetadas;
  }

  //Verifica se a Cadeira está associada a alguma Aula
  Future<bool> verificarCadeiraUtilizadoPorID(int id) async {
    final db = await _dbProvider.database;
    final result = await db.query(
      'Aula',
      where: 'cadeiraID = ?',
      whereArgs: [id],
    );
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
