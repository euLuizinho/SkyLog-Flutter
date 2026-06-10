class UsuarioModel {
  final String uid;
  final String nome;
  final String empresa;
  final String limiarAlerta;
  final String tema;

  UsuarioModel({
    required this.uid,
    required this.nome,
    required this.empresa,
    required this.limiarAlerta,
    required this.tema,
  });

  factory UsuarioModel.fromFirestore(Map<String, dynamic> json, String userId) {
    return UsuarioModel(
      uid: userId,
      nome: json['nome'] as String? ?? 'Gestor SkyLog',
      empresa: json['empresa'] as String? ?? 'Empresa SkyLog',
      limiarAlerta: json['limiar_alerta'] as String? ?? 'BAIXO',
      tema: json['tema'] as String? ?? 'claro',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nome': nome,
      'empresa': empresa,
      'limiar_alerta': limiarAlerta,
      'tema': tema,
    };
  }

  UsuarioModel copyWith({
    String? uid,
    String? nome,
    String? empresa,
    String? limiarAlerta,
    String? tema,
  }) {
    return UsuarioModel(
      uid: uid ?? this.uid,
      nome: nome ?? this.nome,
      empresa: empresa ?? this.empresa,
      limiarAlerta: limiarAlerta ?? this.limiarAlerta,
      tema: tema ?? this.tema,
    );
  }
}
