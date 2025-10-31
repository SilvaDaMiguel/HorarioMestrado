import 'package:flutter/material.dart';
//VARIABLES
import 'variables/enums.dart';

String formatarDataDDMMYYYY(DateTime dt) {
  final dia = dt.day.toString().padLeft(2, '0');
  final mes = dt.month.toString().padLeft(2, '0');
  return '$dia-$mes-${dt.year}';
}

DateTime? stringDDMMYYYYParaDateTime(String dataString) {
  try {
    //Separar a string em dia, mês e ano
    final partes = dataString.split('-');
    if (partes.length != 3) return null;

    final int dia = int.parse(partes[0]);
    final int mes = int.parse(partes[1]);
    final int ano = int.parse(partes[2]);

    //Verificação básica de validade
    if (dia < 1 || dia > 31 || mes < 1 || mes > 12) return null;

    return DateTime(ano, mes, dia);
  } catch (e) {
    return null; //Retorna null se houver erro
  }
}

//Função para remover a hora de um DateTime => Útil para comparar apenas datas (no calendar)
DateTime removerHora(DateTime dt) {
  return DateTime(dt.year, dt.month, dt.day);
}

//Função para converter String ("HH:mm") para TimeOfDay
TimeOfDay? stringParaTimeOfDay(String horaString) {
  try {
    //Divide a string por ":"
    final partes = horaString.split(':');
    if (partes.length != 2) return null;

    final int hora = int.parse(partes[0]);
    final int minuto = int.parse(partes[1]);

    //Verificar se a hora e minuto são válidos
    if (hora < 0 || hora > 23 || minuto < 0 || minuto > 59) return null;

    return TimeOfDay(hour: hora, minute: minuto);
  } catch (e) {
    return null; // Retorna null se der erro no parse
  }
}

//Função para converter TimeOfDay para String ("HH:mm")
String timeOfDayParaString(TimeOfDay hora) {
  final String horaFormatada = hora.hour.toString().padLeft(2, '0');
  final String minutoFormatado = hora.minute.toString().padLeft(2, '0');
  return '$horaFormatada:$minutoFormatado';
}

//Função para determinar o intervalo temporal baseado no momento
Map<String, DateTime> obterIntervaloTempoComMomento(Tempo tempo, Momento momento) {
  final agora = DateTime.now();
  late DateTime inicio;
  late DateTime fim;

  switch (tempo) {
    case Tempo.dia:
      switch (momento) {
        case Momento.passado:
          // Ontem
          inicio = DateTime(agora.year, agora.month, agora.day - 1);
          fim = DateTime(agora.year, agora.month, agora.day);
          break;
        case Momento.agora:
          // Hoje
          inicio = DateTime(agora.year, agora.month, agora.day);
          fim = inicio.add(const Duration(days: 1));
          break;
        case Momento.futuro:
          // Amanhã
          inicio = DateTime(agora.year, agora.month, agora.day + 1);
          fim = inicio.add(const Duration(days: 1));
          break;
      }
      break;

    case Tempo.semana:
      // Segunda-feira da semana atual
      final segundaAtual = agora.subtract(Duration(days: agora.weekday - 1));
      
      switch (momento) {
        case Momento.passado:
          // Semana passada (segunda a domingo)
          inicio = segundaAtual.subtract(const Duration(days: 7));
          fim = segundaAtual;
          break;
        case Momento.agora:
          // Esta semana
          inicio = segundaAtual;
          fim = inicio.add(const Duration(days: 7));
          break;
        case Momento.futuro:
          // Próxima semana
          inicio = segundaAtual.add(const Duration(days: 7));
          fim = inicio.add(const Duration(days: 7));
          break;
      }
      break;

    case Tempo.mes:
      switch (momento) {
        case Momento.passado:
          // Mês passado
          inicio = DateTime(agora.year, agora.month - 1, 1);
          fim = DateTime(agora.year, agora.month, 1);
          break;
        case Momento.agora:
          // Este mês
          inicio = DateTime(agora.year, agora.month, 1);
          fim = DateTime(agora.year, agora.month + 1, 1);
          break;
        case Momento.futuro:
          // Próximo mês
          inicio = DateTime(agora.year, agora.month + 1, 1);
          fim = DateTime(agora.year, agora.month + 2, 1);
          break;
      }
      break;

    case Tempo.ano:
      switch (momento) {
        case Momento.passado:
          // Ano passado
          inicio = DateTime(agora.year - 1, 1, 1);
          fim = DateTime(agora.year, 1, 1);
          break;
        case Momento.agora:
          // Este ano
          inicio = DateTime(agora.year, 1, 1);
          fim = DateTime(agora.year + 1, 1, 1);
          break;
        case Momento.futuro:
          // Próximo ano
          inicio = DateTime(agora.year + 1, 1, 1);
          fim = DateTime(agora.year + 2, 1, 1);
          break;
      }
      break;
  }

  return {'inicio': inicio, 'fim': fim};
}

//Função para obter o DiaSemana (enum) a partir de um DateTime
DiaSemana obterDiaSemana(DateTime data) {
  switch (data.weekday) {
    case DateTime.monday:
      return DiaSemana.segunda;
    case DateTime.tuesday:
      return DiaSemana.terca;
    case DateTime.wednesday:
      return DiaSemana.quarta;
    case DateTime.thursday:
      return DiaSemana.quinta;
    case DateTime.friday:
      return DiaSemana.sexta;
    case DateTime.saturday:
      return DiaSemana.sabado;
    case DateTime.sunday:
      return DiaSemana.domingo;
    default:
      //Prevenção => fallback
      return DiaSemana.segunda;
  }
}

//VERIFICAR HORA PARA PERÍODO DE AULAS
bool verificarHoraExcecao(TimeOfDay horaFinal) {
  //Permitir apenas se a hora final estiver entre 00h00 e 03h00 (inclusive)
  return horaFinal.hour >= 0 && horaFinal.hour <= 3 && horaFinal.minute >= 0;
}

bool verificarHoraInicioFim(TimeOfDay horaInicial, TimeOfDay horaFinal) {
  //TimeOfDay não permite comparação direta através de "<" e ">"
  final inicioMinutos = horaInicial.hour * 60 + horaInicial.minute;
  final fimMinutos = horaFinal.hour * 60 + horaFinal.minute;

  //Se a hora final for menor que a inicial, verifica a exceção
  if (fimMinutos < inicioMinutos) {
    return verificarHoraExcecao(horaFinal);
  }

  //Caso normal
  return inicioMinutos < fimMinutos;
}