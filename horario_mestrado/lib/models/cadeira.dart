import 'dart:convert'; //Carregar JSONs

class Cadeira {
  final int cadeiraID;
  final String nome;
  final String sigla;
  final String informacao;
  final List<String>? professores;
  final int creditos;
  final bool concluida;
  final double? nota;

  Cadeira({
    required this.cadeiraID,
    required this.nome,
    required this.sigla,
    this.informacao = 'Sem Informação',
    this.professores = const [],
    required this.creditos,
    this.concluida = false,
    this.nota,
  });

  factory Cadeira.fromMap(Map<String, dynamic> map) => Cadeira(
        cadeiraID: map['cadeiraID'],
        nome: map['nome'] ?? 'Nome Não Definido',
        sigla: map['sigla'] ?? 'Sigla Não Definida',
        informacao: map['informacao'] ?? 'Sem Informação',
        professores: map['professores'] != null
            ? List<String>.from(jsonDecode(map['professores']))
            : [],
        creditos: map['creditos'] ?? 0,
        concluida: (map['concluida'] ?? 0) == 1, //Converte para bool
        nota: map['nota'] != null
            ? (map['nota'] as num).toDouble() //aceita int ou double
            : null,
      );

  Map<String, dynamic> toMap() => {
        'cadeiraID': cadeiraID,
        'nome': nome,
        'sigla': sigla,
        'informacao': informacao,
        'professores': jsonEncode(professores), //salvar sempre como JSON string
        'creditos': creditos,
        'concluida': concluida ? 1 : 0,
        'nota': nota,
      };
}
