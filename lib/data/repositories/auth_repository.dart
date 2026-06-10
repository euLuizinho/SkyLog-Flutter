import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario_model.dart';

abstract class AuthRepository {
  Stream<User?> get authStateChanges;
  User? get currentUser;
  Future<User?> signIn(String email, String password);
  Future<User?> signUp(String email, String password, String nome, String empresa);
  Future<void> signOut();
  Future<UsuarioModel?> getUsuarioData(String uid);
  Future<void> saveUsuarioData(UsuarioModel usuario);
  Future<void> updateLimiarAlerta(String uid, String limiar);
  Future<void> updateTema(String uid, String tema);
}

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<User?> signIn(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return credential.user;
  }

  @override
  Future<User?> signUp(String email, String password, String nome, String empresa) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    if (credential.user != null) {

      final usuario = UsuarioModel(
        uid: credential.user!.uid,
        nome: nome.trim(),
        empresa: empresa.trim(),
        limiarAlerta: 'BAIXO',
        tema: 'claro',
      );
      await saveUsuarioData(usuario);
    }

    return credential.user;
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<UsuarioModel?> getUsuarioData(String uid) async {
    final doc = await _firestore.collection('usuarios').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UsuarioModel.fromFirestore(doc.data()!, uid);
    }
    return null;
  }

  @override
  Future<void> saveUsuarioData(UsuarioModel usuario) async {
    await _firestore
        .collection('usuarios')
        .doc(usuario.uid)
        .set(usuario.toFirestore());
  }

  @override
  Future<void> updateLimiarAlerta(String uid, String limiar) async {
    await _firestore.collection('usuarios').doc(uid).update({
      'limiar_alerta': limiar,
    });
  }

  @override
  Future<void> updateTema(String uid, String tema) async {
    await _firestore.collection('usuarios').doc(uid).update({
      'tema': tema,
    });
  }
}
