import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/models/alerta_model.dart';
import '../../data/repositories/alerta_repository.dart';

class AlertasViewModel extends ChangeNotifier {
  final AlertaRepository _alertaRepository;
  StreamSubscription<List<AlertaModel>>? _subscription;

  List<AlertaModel> _todosAlertas = [];
  List<AlertaModel> _alertasFiltrados = [];
  String _filtroAtivo = 'TODOS';
  bool _isLoading = true;
  String? _errorMessage;

  AlertasViewModel(this._alertaRepository);

  List<AlertaModel> get alertasFiltrados => _alertasFiltrados;
  String get filtroAtivo => _filtroAtivo;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEmpty => !_isLoading && _alertasFiltrados.isEmpty;

  void init(String limiarMinimo) {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    _subscription?.cancel();
    _subscription = _alertaRepository.getAlertasStream(limiarMinimo).listen(
      (alertas) {
        _todosAlertas = alertas;
        _filtrarAlertas();
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (err) {
        _errorMessage = 'Erro ao carregar lista de alertas.';
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void setFiltro(String filtro) {
    _filtroAtivo = filtro;
    _filtrarAlertas();
    notifyListeners();
  }

  void _filtrarAlertas() {
    if (_filtroAtivo.toUpperCase() == 'TODOS') {
      _alertasFiltrados = _todosAlertas;
    } else {
      _alertasFiltrados = _todosAlertas
          .where((a) => a.classificacao.toUpperCase() == _filtroAtivo.toUpperCase())
          .toList();
    }
  }

  Future<void> marcarComoLido(String id) async {
    try {
      await _alertaRepository.marcarComoLido(id);
    } catch (e) {
      debugPrint('Erro ao marcar como lido: $e');
    }
  }

  Future<void> refresh(String limiarMinimo) async {
    init(limiarMinimo);

    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
