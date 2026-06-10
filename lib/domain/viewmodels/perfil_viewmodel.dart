import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';

class PerfilViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  bool _isLoading = false;

  PerfilViewModel(this._authRepository);

  bool get isLoading => _isLoading;

  Future<void> updateLimiarAlerta(String uid, String limiar) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authRepository.updateLimiarAlerta(uid, limiar);
    } catch (e) {
      debugPrint('Erro ao atualizar limiar: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTema(String uid, String tema) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authRepository.updateTema(uid, tema);
    } catch (e) {
      debugPrint('Erro ao atualizar tema: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authRepository.signOut();
    } catch (e) {
      debugPrint('Erro ao deslogar: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
