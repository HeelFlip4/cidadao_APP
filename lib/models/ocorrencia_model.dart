enum StatusOcorrencia {
  aberta,
  emAndamento,
  resolvida,
  cancelada,
}

class Ocorrencia {
  final String id;
  final String categoria;
  final String subcategoria;
  final String descricao;
  final double latitude;
  final double longitude;
  final List<String> imagens;
  final DateTime dataOcorrencia;
  final StatusOcorrencia status;
  final String? resposta;
  final DateTime? dataResposta;
  final String? responsavel;

  Ocorrencia({
    required this.id,
    required this.categoria,
    required this.subcategoria,
    required this.descricao,
    required this.latitude,
    required this.longitude,
    required this.imagens,
    required this.dataOcorrencia,
    required this.status,
    this.resposta,
    this.dataResposta,
    this.responsavel,
  });

  factory Ocorrencia.fromJson(Map<String, dynamic> json) {
    return Ocorrencia(
      id: json['id'],
      categoria: json['categoria'],
      subcategoria: json['subcategoria'],
      descricao: json['descricao'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      imagens: List<String>.from(json['imagens']),
      dataOcorrencia: DateTime.parse(json['data_ocorrencia']),
      status: StatusOcorrencia.values.firstWhere(
        (e) => e.toString() == 'StatusOcorrencia.${json['status']}',
      ),
      resposta: json['resposta'],
      dataResposta: json['data_resposta'] != null
          ? DateTime.parse(json['data_resposta'])
          : null,
      responsavel: json['responsavel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoria': categoria,
      'subcategoria': subcategoria,
      'descricao': descricao,
      'latitude': latitude,
      'longitude': longitude,
      'imagens': imagens,
      'data_ocorrencia': dataOcorrencia.toIso8601String(),
      'status': status.toString().split('.').last,
      'resposta': resposta,
      'data_resposta': dataResposta?.toIso8601String(),
      'responsavel': responsavel,
    };
  }

  String get statusTexto {
    switch (status) {
      case StatusOcorrencia.aberta:
        return 'Aberta';
      case StatusOcorrencia.emAndamento:
        return 'Em Andamento';
      case StatusOcorrencia.resolvida:
        return 'Resolvida';
      case StatusOcorrencia.cancelada:
        return 'Cancelada';
    }
  }

  String get statusDescricao {
    switch (status) {
      case StatusOcorrencia.aberta:
        return 'Sua ocorrência foi recebida e está aguardando análise';
      case StatusOcorrencia.emAndamento:
        return 'Sua ocorrência está sendo analisada pela equipe responsável';
      case StatusOcorrencia.resolvida:
        return 'Sua ocorrência foi resolvida';
      case StatusOcorrencia.cancelada:
        return 'Sua ocorrência foi cancelada';
    }
  }

  int get diasAbertura {
    return DateTime.now().difference(dataOcorrencia).inDays;
  }

  String get tempoAbertura {
    final diferenca = DateTime.now().difference(dataOcorrencia);
    
    if (diferenca.inDays > 0) {
      return '${diferenca.inDays} dia${diferenca.inDays > 1 ? 's' : ''} atrás';
    } else if (diferenca.inHours > 0) {
      return '${diferenca.inHours} hora${diferenca.inHours > 1 ? 's' : ''} atrás';
    } else if (diferenca.inMinutes > 0) {
      return '${diferenca.inMinutes} minuto${diferenca.inMinutes > 1 ? 's' : ''} atrás';
    } else {
      return 'Agora mesmo';
    }
  }

  String get enderecoFormatado {
    // Em uma implementação real, você faria geocoding reverso aqui
    return 'Lat: ${latitude.toStringAsFixed(6)}, Lng: ${longitude.toStringAsFixed(6)}';
  }

  Ocorrencia copyWith({
    String? id,
    String? categoria,
    String? subcategoria,
    String? descricao,
    double? latitude,
    double? longitude,
    List<String>? imagens,
    DateTime? dataOcorrencia,
    StatusOcorrencia? status,
    String? resposta,
    DateTime? dataResposta,
    String? responsavel,
  }) {
    return Ocorrencia(
      id: id ?? this.id,
      categoria: categoria ?? this.categoria,
      subcategoria: subcategoria ?? this.subcategoria,
      descricao: descricao ?? this.descricao,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      imagens: imagens ?? this.imagens,
      dataOcorrencia: dataOcorrencia ?? this.dataOcorrencia,
      status: status ?? this.status,
      resposta: resposta ?? this.resposta,
      dataResposta: dataResposta ?? this.dataResposta,
      responsavel: responsavel ?? this.responsavel,
    );
  }
}
