class Vaga {
  final String id;
  final String titulo;
  final String descricao;
  final String categoria;
  final String salario;
  final String cargaHoraria;
  final String requisitos;
  final DateTime dataPublicacao;
  final DateTime dataVencimento;
  final String local;
  final int vagas;

  Vaga({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.categoria,
    required this.salario,
    required this.cargaHoraria,
    required this.requisitos,
    required this.dataPublicacao,
    required this.dataVencimento,
    required this.local,
    required this.vagas,
  });

  factory Vaga.fromJson(Map<String, dynamic> json) {
    return Vaga(
      id: json['id'],
      titulo: json['titulo'],
      descricao: json['descricao'],
      categoria: json['categoria'],
      salario: json['salario'],
      cargaHoraria: json['carga_horaria'],
      requisitos: json['requisitos'],
      dataPublicacao: DateTime.parse(json['data_publicacao']),
      dataVencimento: DateTime.parse(json['data_vencimento']),
      local: json['local'],
      vagas: json['vagas'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'categoria': categoria,
      'salario': salario,
      'carga_horaria': cargaHoraria,
      'requisitos': requisitos,
      'data_publicacao': dataPublicacao.toIso8601String(),
      'data_vencimento': dataVencimento.toIso8601String(),
      'local': local,
      'vagas': vagas,
    };
  }

  bool get isVencida => DateTime.now().isAfter(dataVencimento);
  
  int get diasRestantes {
    final diferenca = dataVencimento.difference(DateTime.now());
    return diferenca.inDays;
  }

  String get statusVaga {
    if (isVencida) return 'Vencida';
    if (diasRestantes <= 3) return 'Últimos dias';
    if (diasRestantes <= 7) return 'Encerrando em breve';
    return 'Aberta';
  }
}
