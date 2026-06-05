import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<User?> signInWithGoogle() async {
    try {
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
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<User?> signInWithEmail(String email, String password) async {
    if (!email.endsWith('@souunit.com.br')) {
      throw Exception('Acesso restrito ao e-mail institucional (@souunit.com.br).');
    }
    
    final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    return userCredential.user;
  }

  Future<User?> registerWithEmail(String email, String password) async {
    if (!email.endsWith('@souunit.com.br')) {
      throw Exception('Apenas e-mails institucionais (@souunit.com.br) podem ser cadastrados.');
    }
    
    final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    return userCredential.user;
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await _auth.signOut();
  }
  
  User? get currentUser => _auth.currentUser;
}