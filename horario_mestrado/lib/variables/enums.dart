enum DiaSemana {
  segunda,
  terca,
  quarta,
  quinta,
  sexta,
  sabado,
  domingo,
}

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

enum ficheiros{
  cadeiras,
  periodos,
  aulas
}