import 'package:flutter_test/flutter_test.dart';
import 'package:skylog/data/models/alerta_model.dart';
import 'package:skylog/data/models/usuario_model.dart';

void main() {
  group('Testes de Unidade de Modelos (SkyLog)', () {
    test('AlertaModel - Deve converter de/para mapa de dados do Firestore corretamente', () {
      final mockData = {
        'tipo': 'queimada',
        'localizacao': 'Rodovia BR-163, MT',
        'latitude': -12.556,
        'longitude': -55.722,
        'classificacao': 'CRÍTICO',
        'severidade': 9,
        'horario': '2026-06-06T23:00:00.000Z',
        'fonte': 'INPE',
        'lido': false,
        'status': 'ATIVO',
      };

      final alerta = AlertaModel.fromFirestore(mockData, 'id_alerta_teste');

      expect(alerta.id, equals('id_alerta_teste'));
      expect(alerta.tipo, equals('queimada'));
      expect(alerta.localizacao, equals('Rodovia BR-163, MT'));
      expect(alerta.latitude, equals(-12.556));
      expect(alerta.longitude, equals(-55.722));
      expect(alerta.classificacao, equals('CRÍTICO'));
      expect(alerta.severidade, equals(9));
      expect(alerta.fonte, equals('INPE'));
      expect(alerta.lido, isFalse);
      expect(alerta.status, equals('ATIVO'));
    });

    test('UsuarioModel - Deve criar uma cópia com campos modificados usando copyWith', () {
      final usuario = UsuarioModel(
        uid: 'uid_gestor_1',
        nome: 'Luiz Silva',
        empresa: 'Logística Rápida',
        limiarAlerta: 'BAIXO',
        tema: 'claro',
      );

      final usuarioModificado = usuario.copyWith(
        limiarAlerta: 'CRÍTICO',
        tema: 'escuro',
      );

      // Campos modificados devem mudar
      expect(usuarioModificado.limiarAlerta, equals('CRÍTICO'));
      expect(usuarioModificado.tema, equals('escuro'));
      
      // Outros campos devem permanecer inalterados
      expect(usuarioModificado.uid, equals('uid_gestor_1'));
      expect(usuarioModificado.nome, equals('Luiz Silva'));
      expect(usuarioModificado.empresa, equals('Logística Rápida'));
    });
  });
}
