import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:skylog/data/models/alerta_model.dart';
import 'package:skylog/data/repositories/alerta_repository.dart';
import 'package:skylog/domain/viewmodels/home_viewmodel.dart';

class FakeAlertaRepository implements AlertaRepository {
  final _controller = StreamController<List<AlertaModel>>.broadcast();
  List<AlertaModel> currentAlerts = [];
  bool seedCalled = false;
  bool markAsReadCalled = false;

  @override
  Stream<List<AlertaModel>> getAlertasStream(String limiarMinimo) {
    return _controller.stream;
  }

  void emit(List<AlertaModel> alerts) {
    currentAlerts = alerts;
    _controller.add(alerts);
  }

  @override
  Future<void> marcarComoLido(String id) async {
    markAsReadCalled = true;
  }

  @override
  Future<void> seedAlertasFicticios() async {
    seedCalled = true;
  }

  void dispose() {
    _controller.close();
  }
}

void main() {
  group('HomeViewModel Tests', () {
    late FakeAlertaRepository repository;
    late HomeViewModel viewModel;

    setUp(() {
      repository = FakeAlertaRepository();
      viewModel = HomeViewModel(repository);
    });

    tearDown(() {
      repository.dispose();
    });

    test('Initial state is loading', () {
      expect(viewModel.isLoading, isTrue);
      expect(viewModel.todosAlertas, isEmpty);
      expect(viewModel.alertasRecentes, isEmpty);
    });

    test('init calls seedAlertasFicticios and listens to repository stream', () async {
      await viewModel.init('BAIXO');

      expect(repository.seedCalled, isTrue);
      expect(viewModel.isLoading, isTrue);

      final testAlerts = [
        AlertaModel(
          id: '1',
          tipo: 'queimada',
          localizacao: 'Rodovia A',
          latitude: -10.0,
          longitude: -50.0,
          classificacao: 'CRÍTICO',
          severidade: 9,
          horario: DateTime.now(),
          fonte: 'INPE',
          lido: false,
          status: 'ATIVO',
        ),
        AlertaModel(
          id: '2',
          tipo: 'tempestade',
          localizacao: 'Rodovia B',
          latitude: -11.0,
          longitude: -51.0,
          classificacao: 'MÉDIO',
          severidade: 5,
          horario: DateTime.now(),
          fonte: 'NASA',
          lido: false,
          status: 'ATIVO',
        ),
      ];

      repository.emit(testAlerts);

      // Wait a microtask for the stream listener to trigger
      await Future.delayed(Duration.zero);

      expect(viewModel.isLoading, isFalse);
      expect(viewModel.todosAlertas.length, 2);
      expect(viewModel.totalAlertasAtivos, 2);
      expect(viewModel.alertasCriticos, 1);
      expect(viewModel.rotasSeguras, 12);
    });

    test('selecionarAlerta and limparAlertaSelecionado update selected alert state', () {
      final alert = AlertaModel(
        id: '1',
        tipo: 'queimada',
        localizacao: 'Rodovia A',
        latitude: -10.0,
        longitude: -50.0,
        classificacao: 'CRÍTICO',
        severidade: 9,
        horario: DateTime.now(),
        fonte: 'INPE',
        lido: false,
        status: 'ATIVO',
      );

      viewModel.selecionarAlerta(alert);
      expect(viewModel.alertaSelecionado, equals(alert));

      viewModel.limparAlertaSelecionado();
      expect(viewModel.alertaSelecionado, isNull);
    });
  });
}
