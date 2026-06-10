import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/models/alerta_model.dart';
import '../../data/repositories/alerta_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final AlertaRepository _alertaRepository;
  StreamSubscription<List<AlertaModel>>? _subscription;

  List<AlertaModel> _todosAlertas = [];
  List<AlertaModel> _alertasRecentes = [];
  bool _isLoading = true;
  String? _errorMessage;
  AlertaModel? _alertaSelecionado;

  int _totalAlertasAtivos = 0;
  int _alertasCriticos = 0;
  final int _rotasSeguras = 12;

  HomeViewModel(this._alertaRepository);

  List<AlertaModel> get todosAlertas => _todosAlertas;
  List<AlertaModel> get alertasRecentes => _alertasRecentes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AlertaModel? get alertaSelecionado => _alertaSelecionado;

  int get totalAlertasAtivos => _totalAlertasAtivos;
  int get alertasCriticos => _alertasCriticos;
  int get rotasSeguras => _rotasSeguras;

  Future<void> init(String limiarMinimo) async {
    _isLoading = true;
    notifyListeners();

    try {

      await _alertaRepository.seedAlertasFicticios();
    } catch (e) {
      debugPrint('Erro ao executar seed: $e');
    }

    _subscription?.cancel();
    _subscription = _alertaRepository.getAlertasStream(limiarMinimo).listen(
      (alertas) {
        _todosAlertas = alertas;

        _alertasRecentes = alertas.take(5).toList();

        _totalAlertasAtivos = alertas.where((a) => a.status == 'ATIVO').length;
        _alertasCriticos = alertas
            .where((a) => a.status == 'ATIVO' && a.classificacao == 'CRÍTICO')
            .length;

        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (err) {
        _errorMessage = 'Erro ao carregar dados do mapa.';
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void selecionarAlerta(AlertaModel? alerta) {
    _alertaSelecionado = alerta;
    notifyListeners();
  }

  void limparAlertaSelecionado() {
    _alertaSelecionado = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
