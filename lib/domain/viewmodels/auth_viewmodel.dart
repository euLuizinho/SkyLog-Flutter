import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/models/usuario_model.dart';
import '../../data/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  User? _currentUser;
  UsuarioModel? _userProfile;
  bool _isLoading = false;
  String? _errorMessage;

  AuthViewModel(this._authRepository) {
    _currentUser = _authRepository.currentUser;
    if (_currentUser != null) {
      _loadProfile(_currentUser!.uid);
    }

    _authRepository.authStateChanges.listen((user) async {
      _currentUser = user;
      if (user != null) {
        await _loadProfile(user.uid);
      } else {
        _userProfile = null;
      }
      notifyListeners();
    });
  }

  User? get currentUser => _currentUser;
  UsuarioModel? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  Future<void> _loadProfile(String uid) async {
    try {
      _userProfile = await _authRepository.getUsuarioData(uid);
    } catch (e) {
      debugPrint('Erro ao carregar perfil: $e');
    }
  }

  Future<void> reloadProfile() async {
    if (_currentUser != null) {
      await _loadProfile(_currentUser!.uid);
      notifyListeners();
    }
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authRepository.signIn(email, password);
      return user != null;
    } catch (e) {
      _errorMessage = _parseError(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signUp(String email, String password, String nome, String empresa) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authRepository.signUp(email, password, nome, empresa);
      return user != null;
    } catch (e) {
      _errorMessage = _parseError(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }

  Future<void> updateLimiarAlerta(String limiar) async {
    if (_currentUser == null || _userProfile == null) return;
    _userProfile = _userProfile!.copyWith(limiarAlerta: limiar);
    notifyListeners();
    try {
      await _authRepository.updateLimiarAlerta(_currentUser!.uid, limiar);
    } catch (e) {
      debugPrint('Erro ao atualizar limiar: $e');
    }
  }

  Future<void> updateTema(String tema) async {
    if (_currentUser == null || _userProfile == null) return;
    _userProfile = _userProfile!.copyWith(tema: tema);
    notifyListeners();
    try {
      await _authRepository.updateTema(_currentUser!.uid, tema);
    } catch (e) {
      debugPrint('Erro ao atualizar tema: $e');
    }
  }

  String _parseError(dynamic e) {
    final str = e.toString();
    if (str.contains('invalid-email') || str.contains('invalid-credential') || str.contains('wrong-password') || str.contains('user-not-found')) {
      return 'E-mail ou senha incorretos.';
    } else if (str.contains('email-already-in-use')) {
      return 'Este e-mail já está em uso.';
    } else if (str.contains('weak-password')) {
      return 'A senha deve conter no mínimo 6 caracteres.';
    } else if (str.contains('network-request-failed')) {
      return 'Sem conexão com a internet. Verifique sua rede.';
    }
    return 'Falha na autenticação: ${e.toString().split(']').last.trim()}';
  }
}
