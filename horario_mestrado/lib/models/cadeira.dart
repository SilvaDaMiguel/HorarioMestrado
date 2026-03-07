import 'dart:convert'; //Carregar JSONs

class Cadeira {
  final int id;
  final String nome;
  final String sigla;
  final int ano;
  final int semestre;
  final String informacao;
  final List<String>? professores;
  final int creditos;
  final bool concluida;
  final double? nota;

  Cadeira({
    required this.id,
    required this.nome,
    required this.sigla,
    required this.ano,
    required this.semestre,
    this.informacao = 'Sem Informação',
    this.professores = const [],
    required this.creditos,
    this.concluida = false,
    this.nota,
  });

  factory Cadeira.fromMap(Map<String, dynamic> map) => Cadeira(
    id: map['id'],
    nome: map['nome'] ?? 'Nome Não Definido',
    sigla: map['sigla'] ?? 'Sigla Não Definida',
    ano: map['ano'],
    semestre: map['semestre'],
    informacao: map['informacao'] ?? 'Sem Informação',
    /*
        professores: map['professores'] != null
            ? List<String>.from(jsonDecode(map['professores']))
            : [],
            */
    professores: map['professores'] is String
        ? List<String>.from(
            jsonDecode(map['professores']),
          ) //"professores": ["professor1", "professor2"]
        : List<String>.from(
            map['professores'] ?? [],
          ), //"professores": "[\"professor1\",\"professor2\"]"
    creditos: map['creditos'] ?? 0,
    concluida: (map['concluida'] ?? 0) == 1, //Converte para bool
    nota: map['nota'] != null
        ? (map['nota'] as num)
              .toDouble() //aceita int ou double
        : null,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'nome': nome,
    'sigla': sigla,
    'ano': ano,
    'semestre': semestre,
    'informacao': informacao,
    'professores': jsonEncode(professores), //salvar sempre como JSON string
    'creditos': creditos,
    'concluida': concluida ? 1 : 0,
    'nota': nota,
  };
}
