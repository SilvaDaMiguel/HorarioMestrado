import 'package:flutter/material.dart';

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





/*
//Função para formatar a hora (String)
String formatarHora(String hora) {
  try {
    //Dividir a string da hora em partes (Hora, Minuto, Segundo)
    List<String> partes = hora.split(':');

    if (partes.length != 3) {
      return 'Formato de hora inválido';
    }

    //Escolher as partes das horas e minutos
    String horas = partes[0].padLeft(2, '0');
    String minutos = partes[1].padLeft(2, '0');

    //Formatar a hora para o formato 'Hora H Minutos'
    return '${horas}H$minutos';
  } catch (e) {
    // Se houver um erro, retorna uma string de erro
    return 'Formato de hora inválido';
  }
}
*/