//RESPONSÁVEL PELAS OPERAÇÕES CRUD
import 'database.dart';
import 'storage_json.dart';
//MODELS
import '../models/periodo.dart';
import '../models/cadeira.dart';
import '../models/aula.dart';
//VARIABLES
import '../variables/enums.dart';
//FUNCTIONS
import '../functions.dart';

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
    String filtro,
  ) async {
    final db = await _dbProvider.database;

    final result = await db.query(
      'Periodo',
      where: 'diaSemana = ?', //Condição WHERE
      whereArgs: [filtro],
      orderBy:
          'diaSemana, horaInicio', //Ordenar por dia da semana e hora de início
    );

    return result.map((e) => Periodo.fromMap(e)).toList();
  }

  Future<int> obterNovoIDPeriodo() async {
    final db = await _dbProvider.database;
    final result = await db.rawQuery(
      'SELECT MAX(periodoID) as maxId FROM Periodo',
    );
    final maxId = result.first['maxId'] as int?;
    return (maxId ?? 0) + 1;
  }

  Future<int> adicionarPeriodo(Periodo periodo) async {
    final db = await _dbProvider.database;
    final id = await db.insert('Periodo', periodo.toMap());

    //Adiciona o novo item ao JSON LOCAL
    await JsonCrud.adicionarDadoJSON(
      '${Ficheiros.periodos.nomeFicheiro}.json',
      periodo.toMap(),
    );

    return id;
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

  Future<int> apagarPeriodo(int id) async {
    try {
      //Verifica se o Periodo está associada a alguma Aula
      final periodoEmUso = await verificarPeriodoUtilizadoPorID(id);
      if (periodoEmUso) {
        throw Exception(
          'Não é possível apagar o período porque está associado a uma ou mais aulas.',
        );
      }
    } catch (e) {
      rethrow;
    }
    final db = await _dbProvider.database;

    //Apaga da BD
    final linhasAfetadas = await db.delete(
      'Periodo',
      where: 'periodoID = ?',
      whereArgs: [id],
    );

    //Se a remoção na BD for bem sucedida, remove do JSON LOCAL
    if (linhasAfetadas > 0) {
      await JsonCrud.apagarDadoJSON(
        '${Ficheiros.periodos.nomeFicheiro}.json',
        id,
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
      return false;
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
    try {
      //Verifica se a Cadeira está associada a alguma Aula
      final cadeiraEmUso = await verificarCadeiraUtilizadoPorID(id);
      if (cadeiraEmUso) {
        throw Exception(
          'Não é possível apagar a cadeira porque está associada a uma ou mais aulas.',
        );
      }
    } catch (e) {
      rethrow;
    }
    final db = await _dbProvider.database;

    //Apaga da BD
    final linhasAfetadas = await db.delete(
      'Cadeira',
      where: 'cadeiraID = ?',
      whereArgs: [id],
    );

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
      return false;
    }
  }

  //AULA
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

  Future<List<Aula>> obterAulasFiltradasPorMomentoTempo(
    String? momento,
    Tempo tempo,
  ) async {
    final db = await _dbProvider.database;

    // Obter intervalo (inicio e fim)
    final intervalo = obterIntervaloTempo(tempo);
    final inicio = intervalo['inicio']!;
    final fim = intervalo['fim']!;

    // Converter para yyyy-MM-dd (formato comparável)
    final dataInicio =
        '${inicio.year.toString().padLeft(4, '0')}-'
        '${inicio.month.toString().padLeft(2, '0')}-'
        '${inicio.day.toString().padLeft(2, '0')}';

    final dataFim =
        '${fim.year.toString().padLeft(4, '0')}-'
        '${fim.month.toString().padLeft(2, '0')}-'
        '${fim.day.toString().padLeft(2, '0')}';

    //Construir WHERE
    final whereClauses = <String>[];
    final whereArgs = <dynamic>[];

    //Converter campo data (dd-MM-yyyy) → yyyy-MM-dd para comparar
    const dataConvertida =
        "(substr(data, 7, 4) || '-' || substr(data, 4, 2) || '-' || substr(data, 1, 2))";

    //Filtro base: dentro do intervalo de tempo
    whereClauses.add("$dataConvertida >= ? AND $dataConvertida < ?");
    whereArgs.addAll([dataInicio, dataFim]);

    //Data atual (para comparar aulas passadas ou futuras)
    final agora = DateTime.now();
    final hoje =
        '${agora.year.toString().padLeft(4, '0')}-'
        '${agora.month.toString().padLeft(2, '0')}-'
        '${agora.day.toString().padLeft(2, '0')}';

    //Filtro de momento temporal
    if (momento != null && momento.isNotEmpty) {
      if (momento == '<') {
        whereClauses.add('$dataConvertida < ?');
        whereArgs.add(hoje);
      } else if (momento == '>') {
        whereClauses.add('$dataConvertida > ?');
        whereArgs.add(hoje);
      }
      // Se for "", não adiciona nada (mostra todas)
    }

    final result = await db.query(
      'Aula',
      where: whereClauses.join(' AND '),
      whereArgs: whereArgs,
      orderBy: '$dataConvertida ASC',
    );

    return result.map((e) => Aula.fromMap(e)).toList();
  }

  Future<int> obterNovoIDAula() async {
    final db = await _dbProvider.database;
    final result = await db.rawQuery('SELECT MAX(aulaID) as maxId FROM Aula');
    final maxId = result.first['maxId'] as int?;
    return (maxId ?? 0) + 1;
  }

  Future<int> adicionarAula(Aula aula) async {
    final db = await _dbProvider.database;
    final id = await db.insert('Aula', aula.toMap());

    //Adiciona o novo item ao JSON LOCAL
    await JsonCrud.adicionarDadoJSON(
      '${Ficheiros.aulas.nomeFicheiro}.json',
      aula.toMap(),
    );

    return id;
  }

  Future<int> atualizarAula(Aula aula) async {
    final db = await _dbProvider.database;

    //Atualiza a BD
    final linhasAfetadas = await db.update(
      'Aula',
      aula.toMap(),
      where: 'aulaID = ?',
      whereArgs: [aula.aulaID],
    );

    //Se a atualização na BD for bem sucedida, atualiza o JSON LOCAL
    if (linhasAfetadas > 0) {
      await JsonCrud.atualizarDadoJSON(
        '${Ficheiros.aulas.nomeFicheiro}.json',
        aula.aulaID,
        aula.toMap(),
      );
    }

    return linhasAfetadas;
  }

  Future<int> apagarAula(int id) async {
    final db = await _dbProvider.database;

    //Apaga da BD
    final linhasAfetadas = await db.delete(
      'Aula',
      where: 'aulaID = ?',
      whereArgs: [id],
    );

    //Se a remoção na BD for bem sucedida, remove do JSON LOCAL
    if (linhasAfetadas > 0) {
      await JsonCrud.apagarDadoJSON(
        '${Ficheiros.aulas.nomeFicheiro}.json',
        id,
      );
    }

    return linhasAfetadas;
  }

  //RESET => PERIGO
  Future<void> resetBaseDeDados() async {
    await _dbProvider.deleteDatabaseFile();
  }
}
