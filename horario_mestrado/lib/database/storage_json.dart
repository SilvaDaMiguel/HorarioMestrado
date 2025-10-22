import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';


class JsonStorage {
  //Copia um ficheiro JSON dos assets para o armazenamento local, se ainda não existir
  static Future<File> initJsonFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final localFile = File('${directory.path}/$fileName');

    if (!await localFile.exists()) {
      final data = await rootBundle.loadString('assets/json/$fileName');
      await localFile.writeAsString(data);
    }
    return localFile;
  }

  //Obtém o ficheiro local
  static Future<File> getLocalJsonFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$fileName');
  }
}

class JsonCrud {
  //Abre o JSON LOCAL => Converte Texto numa Lista de Maps
  static Future<List<Map<String, dynamic>>> lerJSON(String fileName) async {
    final file = await JsonStorage.getLocalJsonFile(fileName);
    final content = await file.readAsString();
    return List<Map<String, dynamic>>.from(jsonDecode(content));
  }

  //Substitui todos os dados do JSON LOCAL => Sobrescreve o ficheiro
  static Future<void> guardarJSON(String fileName, List<Map<String, dynamic>> data) async {
    final file = await JsonStorage.getLocalJsonFile(fileName);
    await file.writeAsString(jsonEncode(data));
  }

  //Atualiza os dados JSON LOCAL de um Item específico => Utiliza o ID
  static Future<void> atualizarDadoJSON(String fileName, int id, Map<String, dynamic> novosDados) async {
    final data = await lerJSON(fileName);
    print('Ficheiro JSON: $fileName');
    final index = data.indexWhere((item) => item['id'] == id);
    if (index != -1) {
      data[index] = {...data[index], ...novosDados};
      await guardarJSON(fileName, data);
    }
  }

  //Adiciona um novo Item ao JSON LOCAL
  static Future<void> adicionarDadoJSON(String fileName, Map<String, dynamic> novo) async {
    final data = await lerJSON(fileName);
    print('Ficheiro JSON: $fileName');
    data.add(novo);
    await guardarJSON(fileName, data);
  }

  //Apaga um Item específico do JSON LOCAL => Utiliza o ID
  static Future<void> apagarDadoJSON(String fileName, int id) async {
    final data = await lerJSON(fileName);
    print('Ficheiro JSON: $fileName');
    data.removeWhere((item) => item['id'] == id);
    await guardarJSON(fileName, data);
  }

}
