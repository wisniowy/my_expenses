import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FlutterFireAuthService {
  final FirebaseAuth _firebaseAuth;

  FlutterFireAuthService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.idTokenChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<bool> signIn({required String email,
    required String password,}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      print("Signed In");
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<String?> signUp({required String email,
    required String password,}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "Success";
    } on FirebaseAuthException catch (e) {
      switch (e.message) {
        case "email-already-in-use":
          return "Email is already in use";
        case "weak-password":
          return "Password is too weak";
        case "invalid-email":
          return "Email is invalid";
        default:
          return "Error";
      }
    }
  }

  Future<String?> signInWithGoogle({required BuildContext context}) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    print("Credentials");

    // return await _firebaseAuth.signInWithCredential(credential);
    try {
      await _firebaseAuth.signInWithCredential(credential);
      print("Signed In with google");
      return "Success";
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      return e.message;
    }// Once signed in, return the UserCredential
  }

}