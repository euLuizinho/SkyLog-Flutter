import 'package:cloud_firestore/cloud_firestore.dart';

class AlertaModel {
  final String id;
  final String tipo;
  final String localizacao;
  final double latitude;
  final double longitude;
  final String classificacao;
  final int severidade;
  final DateTime horario;
  final String fonte;
  final bool lido;
  final String status;

  AlertaModel({
    required this.id,
    required this.tipo,
    required this.localizacao,
    required this.latitude,
    required this.longitude,
    required this.classificacao,
    required this.severidade,
    required this.horario,
    required this.fonte,
    required this.lido,
    required this.status,
  });

  factory AlertaModel.fromFirestore(Map<String, dynamic> json, String docId) {
    DateTime parsedHorario;
    var rawHorario = json['horario'];
    if (rawHorario is Timestamp) {
      parsedHorario = rawHorario.toDate();
    } else if (rawHorario is String) {
      parsedHorario = DateTime.tryParse(rawHorario) ?? DateTime.now();
    } else {
      parsedHorario = DateTime.now();
    }

    return AlertaModel(
      id: docId,
      tipo: json['tipo'] as String? ?? '',
      localizacao: json['localizacao'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      classificacao: json['classificacao'] as String? ?? 'BAIXO',
      severidade: (json['severidade'] as num?)?.toInt() ?? 0,
      horario: parsedHorario,
      fonte: json['fonte'] as String? ?? 'Sistema',
      lido: json['lido'] as bool? ?? false,
      status: json['status'] as String? ?? 'ATIVO',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'tipo': tipo,
      'localizacao': localizacao,
      'latitude': latitude,
      'longitude': longitude,
      'classificacao': classificacao,
      'severidade': severidade,
      'horario': Timestamp.fromDate(horario),
      'fonte': fonte,
      'lido': lido,
      'status': status,
    };
  }

  AlertaModel copyWith({
    String? id,
    String? tipo,
    String? localizacao,
    double? latitude,
    double? longitude,
    String? classificacao,
    int? severidade,
    DateTime? horario,
    String? fonte,
    bool? lido,
    String? status,
  }) {
    return AlertaModel(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      localizacao: localizacao ?? this.localizacao,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      classificacao: classificacao ?? this.classificacao,
      severidade: severidade ?? this.severidade,
      horario: horario ?? this.horario,
      fonte: fonte ?? this.fonte,
      lido: lido ?? this.lido,
      status: status ?? this.status,
    );
  }
}
