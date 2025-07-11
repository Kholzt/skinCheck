import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// A service class to handle Firebase Authentication:
/// - Google Sign-In
/// - Email/Password login & register
/// - Forgot Password
class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// 🔐 Login with Google
  Future<User?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      print("Logged in with Google: ${userCredential.user?.email}");
      return userCredential.user;
    } catch (e) {
      print("Sign-in error (Google): $e");
      return null;
    }
  }

  /// 📧 Login with email & password
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("Logged in: ${userCredential.user?.email}");
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Login error (email/password): ${e.code}");
      return null;
    }
  }

  /// 🆕 Register with email & password
  Future<User?> registerWithEmailPassword(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("Registered: ${userCredential.user?.email}");
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Register error: ${e.code}");
      return null;
    }
  }

  /// 🔁 Forgot password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print("Password reset email sent to: $email");
    } catch (e) {
      print("Reset password error: $e");
    }
  }

  User? getUser() {
    return FirebaseAuth.instance.currentUser;
  }

  /// 🔓 Sign out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    print("User signed out");
  }
}
