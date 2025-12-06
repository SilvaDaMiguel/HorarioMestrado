import 'package:shared_preferences/shared_preferences.dart';
//VARIABLES
import '../variables/enums.dart';

class PreferenceService {
  //Variáveis para as preferências
  static const FiltroCadeiras filtroCadeiras = FiltroCadeiras.ano1semestre1;

  //Guarda o ano e semestre escolhido (ex: "1ºAno 1º Semestre")
  static Future<bool> saveFiltroCadeiras(FiltroCadeiras filtro) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setInt('filtroCadeiras', filtro.index);
  }

  //Carrega o ano e semestre. Devolve null se não encontrar.
  static Future<FiltroCadeiras?> loadFiltroCadeiras() async {
    final prefs = await SharedPreferences.getInstance();
    final filtroIndex = prefs.getInt('filtroCadeiras');
    if (filtroIndex != null && filtroIndex >= 0 && filtroIndex < FiltroCadeiras.values.length) {
      return FiltroCadeiras.values[filtroIndex];
    }
    return null;
  }

  //Função para limpar todas as preferências
  static Future<bool> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
}