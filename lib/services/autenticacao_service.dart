import 'package:firebase_auth/firebase_auth.dart';

class AutenticacaoService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Checar se usuário está logado
  User? get usuarioLogado => _auth.currentUser;

  // Login
  Future<User?> login(String email, String senha) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Retorna null em caso de erro
      print(e); // Para debug
      return null;
    }
  }

  // Cadastro
  Future<User?> cadastrar(String email, String senha) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Retorna null em caso de erro
      print(e); // Para debug
      return null;
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
