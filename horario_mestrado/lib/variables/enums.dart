enum DiaSemana { segunda, terca, quarta, quinta, sexta, sabado, domingo }

//Converter o Enum em String e Corretamente!
extension DiaSemanaExtension on DiaSemana {
  String get nomeComAcento {
    switch (this) {
      case DiaSemana.segunda:
        return 'Segunda';
      case DiaSemana.terca:
        return 'Terça';
      case DiaSemana.quarta:
        return 'Quarta';
      case DiaSemana.quinta:
        return 'Quinta';
      case DiaSemana.sexta:
        return 'Sexta';
      case DiaSemana.sabado:
        return 'Sábado';
      case DiaSemana.domingo:
        return 'Domingo';
    }
  }
}

enum Ficheiros { cadeiras, periodos, aulas }

//Converter o Enum em String e Corretamente!
extension FicheirosExtension on Ficheiros {
  String get nomeFicheiro {
    switch (this) {
      case Ficheiros.cadeiras:
        return 'cadeiras';
      case Ficheiros.periodos:
        return 'periodos';
      case Ficheiros.aulas:
        return 'aulas';
    }
  }
}

//Para filtro do tipo: Aulas (Todas, Passadas, Futuras)
enum Momento { passado, agora, futuro }

extension MomentoExtension on Momento {
  String get momentoAulas {
    switch (this) {
      case Momento.agora:
        return 'Atual';
      case Momento.passado:
        return 'Passada';
      case Momento.futuro:
        return 'Próxima';
    }
  }
}

enum Tempo { dia, semana, mes, ano }

extension TempoExtension on Tempo {
  String get nomeTempo {
    switch (this) {
      case Tempo.dia:
        return 'Dia';
      case Tempo.semana:
        return 'Semana';
      case Tempo.mes:
        return 'Mês';
      case Tempo.ano:
        return 'Ano';
    }
  }
}

//Para filtro das cadeiras por ano e semestre
enum FiltroCadeiras {
  ano1semestre1,
  ano1semestre2,
  ano2semestre1,
  ano2semestre2,
}

extension FiltroCadeirasStringExtension on FiltroCadeiras {
  String get nomeFiltro {
    switch (this) {
      case FiltroCadeiras.ano1semestre1:
        return '1º Ano - 1º Semestre';
      case FiltroCadeiras.ano1semestre2:
        return '1º Ano - 2º Semestre';
      case FiltroCadeiras.ano2semestre1:
        return '2º Ano - 1º Semestre';
      case FiltroCadeiras.ano2semestre2:
        return '2º Ano - 2º Semestre';
    }
  }
}

extension FiltroCadeirasIntExtension on FiltroCadeiras {
  List<int> get valorFiltro {
    switch (this) {
      case FiltroCadeiras.ano1semestre1:
        return [1, 1];
      case FiltroCadeiras.ano1semestre2:
        return [1, 2];
      case FiltroCadeiras.ano2semestre1:
        return [2, 1];
      case FiltroCadeiras.ano2semestre2:
        return [2, 2];
    }
  }
}
