import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/alerta_model.dart';

abstract class AlertaRepository {
  Stream<List<AlertaModel>> getAlertasStream(String limiarMinimo);
  Future<void> marcarComoLido(String id);
  Future<void> seedAlertasFicticios();
}

class AlertaRepositoryImpl implements AlertaRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int _getPriority(String classification) {
    switch (classification.toUpperCase()) {
      case 'CRÍTICO':
        return 4;
      case 'ALTO':
        return 3;
      case 'MÉDIO':
        return 2;
      case 'BAIXO':
      default:
        return 1;
    }
  }

  @override
  Stream<List<AlertaModel>> getAlertasStream(String limiarMinimo) {
    final int userPriority = _getPriority(limiarMinimo);

    return _firestore
        .collection('alertas')
        .orderBy('horario', descending: true)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs.map((doc) {
        return AlertaModel.fromFirestore(doc.data(), doc.id);
      }).toList();

      return list.where((alerta) {
        return _getPriority(alerta.classificacao) >= userPriority;
      }).toList();
    });
  }

  @override
  Future<void> marcarComoLido(String id) async {
    await _firestore.collection('alertas').doc(id).update({
      'lido': true,
    });
  }

  @override
  Future<void> seedAlertasFicticios() async {
    final snapshot = await _firestore.collection('alertas').limit(1).get();
    if (snapshot.docs.isNotEmpty) {

      return;
    }

    final batch = _firestore.batch();
    final collection = _firestore.collection('alertas');

    final mockAlertas = [
      AlertaModel(
        id: '',
        tipo: 'queimada',
        localizacao: 'Rodovia BR-163, MT',
        latitude: -12.556,
        longitude: -55.722,
        classificacao: 'CRÍTICO',
        severidade: 9,
        horario: DateTime.now().subtract(const Duration(minutes: 15)),
        fonte: 'INPE',
        lido: false,
        status: 'ATIVO',
      ),
      AlertaModel(
        id: '',
        tipo: 'enchente',
        localizacao: 'Rodovia BR-101, SC',
        latitude: -27.596,
        longitude: -48.548,
        classificacao: 'ALTO',
        severidade: 7,
        horario: DateTime.now().subtract(const Duration(hours: 1)),
        fonte: 'NASA EONET',
        lido: false,
        status: 'ATIVO',
      ),
      AlertaModel(
        id: '',
        tipo: 'deslizamento',
        localizacao: 'Rodovia BR-116, RJ',
        latitude: -22.425,
        longitude: -42.982,
        classificacao: 'CRÍTICO',
        severidade: 10,
        horario: DateTime.now().subtract(const Duration(hours: 3)),
        fonte: 'INPE',
        lido: false,
        status: 'ATIVO',
      ),
      AlertaModel(
        id: '',
        tipo: 'tempestade',
        localizacao: 'Rodovia BR-290, RS',
        latitude: -30.034,
        longitude: -51.217,
        classificacao: 'MÉDIO',
        severidade: 5,
        horario: DateTime.now().subtract(const Duration(hours: 5)),
        fonte: 'NASA EONET',
        lido: false,
        status: 'ATIVO',
      ),
      AlertaModel(
        id: '',
        tipo: 'queimada',
        localizacao: 'Rodovia BR-020, BA',
        latitude: -12.152,
        longitude: -44.998,
        classificacao: 'ALTO',
        severidade: 8,
        horario: DateTime.now().subtract(const Duration(hours: 8)),
        fonte: 'INPE',
        lido: false,
        status: 'ATIVO',
      ),
      AlertaModel(
        id: '',
        tipo: 'tempestade',
        localizacao: 'Rodovia BR-364, RO',
        latitude: -8.761,
        longitude: -63.903,
        classificacao: 'BAIXO',
        severidade: 3,
        horario: DateTime.now().subtract(const Duration(days: 1)),
        fonte: 'NASA EONET',
        lido: false,
        status: 'ATIVO',
      ),
      AlertaModel(
        id: '',
        tipo: 'deslizamento',
        localizacao: 'Rodovia BR-376, PR',
        latitude: -25.863,
        longitude: -48.966,
        classificacao: 'MÉDIO',
        severidade: 6,
        horario: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
        fonte: 'INPE',
        lido: false,
        status: 'ATIVO',
      ),
      AlertaModel(
        id: '',
        tipo: 'enchente',
        localizacao: 'Rodovia BR-222, CE',
        latitude: -3.731,
        longitude: -38.526,
        classificacao: 'BAIXO',
        severidade: 2,
        horario: DateTime.now().subtract(const Duration(days: 2)),
        fonte: 'NASA EONET',
        lido: false,
        status: 'ATIVO',
      ),
    ];

    for (var alerta in mockAlertas) {
      final docRef = collection.doc();
      batch.set(docRef, alerta.toFirestore());
    }

    await batch.commit();
  }
}
