import 'package:shared_preferences/shared_preferences.dart';
//VARIABLES
import '../variables/enums.dart';

class PreferenceService {
  //Variáveis para as preferências
  static const FiltroCadeiras filtroCadeiras = FiltroCadeiras.ano1semestre1;
  static const String? salaDefault = null; //Pode ser null para indicar "sem preferência"

  //Guarda o ano e semestre escolhido (ex: "1ºAno 1º Semestre")
  static Future<bool> saveFiltroCadeiras(FiltroCadeiras filtro) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setInt('filtroCadeiras', filtro.index);
  }

  //Guarda a sala default. Recebe null para indicar ausência de preferência.
  static Future<bool> saveSalaDefault(String? sala) async {
    final prefs = await SharedPreferences.getInstance();
    if (sala == null) {
      return prefs.remove('salaDefault');
    }
    return prefs.setString('salaDefault', sala);
  }

  //Carrega o ano e semestre. Devolve null se não encontrar.
  static Future<FiltroCadeiras?> loadFiltroCadeiras() async {
    final prefs = await SharedPreferences.getInstance();
    final filtroIndex = prefs.getInt('filtroCadeiras');
    if (filtroIndex != null && filtroIndex >= 0 && filtroIndex < FiltroCadeiras.values.length) {
      return FiltroCadeiras.values[filtroIndex];
    }

    //Se não existir preferência guardada, devolve o valor default em vez de null
    return FiltroCadeiras.ano1semestre1;
  }

  //Carrega a sala default, devolve null se não existir preferência
  static Future<String?> loadSalaDefault() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('salaDefault');
  }

  //Função para limpar todas as preferências
  static Future<bool> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
}