class Periodo {
  final int periodoID;
  final String diaSemana;
  final String horaInicio; // Formato "HH:MM"
  final String horaFim; // Formato "HH:MM"

  Periodo({
    required this.periodoID,
    required this.diaSemana,
    required this.horaInicio,
    required this.horaFim,
  });

  factory Periodo.fromMap(Map<String, dynamic> map) => Periodo(
    periodoID: map['periodoID'],
    diaSemana: map['diaSemana'],
    horaInicio: map['horaInicio'],
    horaFim: map['horaFim'],
  );

  Map<String, dynamic> toMap() => {
    'periodoID': periodoID,
    'diaSemana': diaSemana,
    'horaInicio': horaInicio,
    'horaFim': horaFim,
  };

}