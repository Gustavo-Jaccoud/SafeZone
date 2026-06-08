import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<User?> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return null;

      if (!googleUser.email.endsWith('@souunit.com.br')) {
        await _googleSignIn.signOut();
        throw Exception('Acesso restrito ao e-mail institucional (@souunit.com.br).');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null && !userCredential.user!.email!.endsWith('@souunit.com.br')) {
        await signOut();
        throw Exception('Acesso restrito ao e-mail institucional (@souunit.com.br).');
      }

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_getFriendlyErrorMessage(e.code));
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<User?> signInWithEmail(String email, String password) async {
    if (!email.endsWith('@souunit.com.br')) {
      throw Exception('Acesso restrito ao e-mail institucional (@souunit.com.br).');
    }

    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_getFriendlyErrorMessage(e.code));
    } catch (e) {
      throw Exception('Ocorreu um erro inesperado ao fazer login.');
    }
  }

  Future<User?> registerWithEmail(String email, String password) async {
    if (!email.endsWith('@souunit.com.br')) {
      throw Exception('Apenas e-mails institucionais (@souunit.com.br) podem ser cadastrados.');
    }

    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_getFriendlyErrorMessage(e.code));
    } catch (e) {
      throw Exception('Ocorreu um erro inesperado ao cadastrar.');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(_getFriendlyErrorMessage(e.code));
    } catch (e) {
      throw Exception('Ocorreu um erro inesperado ao redefinir a senha.');
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;

  String _getFriendlyErrorMessage(String code) {
    switch (code) {
      case 'invalid-credential':
        return 'E-mail ou senha incorretos.';
      case 'user-not-found':
        return 'Nenhum usuário encontrado com este e-mail.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'email-already-in-use':
        return 'Este e-mail já está cadastrado.';
      case 'weak-password':
        return 'A senha deve ter pelo menos 6 caracteres.';
      case 'invalid-email':
        return 'Formato de e-mail inválido.';
      case 'user-disabled':
        return 'Esta conta foi desativada.';
      case 'too-many-requests':
        return 'Muitas tentativas falhas. Tente novamente mais tarde.';
      case 'network-request-failed':
        return 'Sem conexão com a internet. Verifique sua rede.';
      default:
        return 'Erro de autenticação. Tente novamente.';
    }
  }
}