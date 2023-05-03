import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AccessServices extends ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;
  User? currentUser;
  bool loading = false;

  void showLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  Future<bool> registerUsingEmailPassword({
    required String email,
    required String password,
    required void Function(String message) showSnackbar,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      currentUser = userCredential.user;
      showSnackbar("Berhasil Register");
      return currentUser != null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackbar("The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        showSnackbar("The account already exists for that email.");
      }
      return false;
    } catch (e) {
      showSnackbar("Error Happened");
      return false;
    }
  }

  Future<bool> signInUsingEmailPassword({
    required String email,
    required String password,
    required void Function(String message) showSnackbar,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      currentUser = userCredential.user;
      showSnackbar("Berhasil Login");
      return currentUser != null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackbar("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        showSnackbar("Wrong password provided.");
      }
      return false;
    }
  }

  // Masih Belum Bisa Google Sign In nya
  Future<bool> signInWithGoogle({
    required void Function(String message) showSnackbar,
  }) async {
    final googleSignIn = GoogleSignIn(scopes: [
      'email',
      'https://www.googleapis.com/auth/drive',
      'https://www.googleapis.com/auth/contacts.readonly',
    ]);
    final googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuth =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuth.accessToken,
        idToken: googleSignInAuth.idToken,
      );
      try {
        final UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        currentUser = userCredential.user;
        print(userCredential.user ?? "");
        return userCredential.user != null;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          showSnackbar(
              "The account already exists with a different credential");
        } else if (e.code == 'invalid-credential') {
          showSnackbar(
              "Error occurred while accessing credentials. Try again.");
        }
        return false;
      } catch (e) {
        showSnackbar("Error occurred using Google Sign In. Try again.");
        return false;
      }
    }
    return false;
  }

  void logout() async{
    await _firebaseAuth.signOut();
    currentUser = null;
    notifyListeners();
  }
}
