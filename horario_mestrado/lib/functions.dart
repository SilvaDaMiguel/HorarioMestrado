//Função para remover a hora de um DateTime => Útil para comparar apenas datas (no calendar)
DateTime removerHora(DateTime dt) {
  return DateTime(dt.year, dt.month, dt.day);
}

//Função para formatar a hora (String) => Útil para exibir no app
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

