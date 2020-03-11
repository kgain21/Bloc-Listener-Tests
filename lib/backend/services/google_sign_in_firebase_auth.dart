import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'base_authentication_service.dart';

class GoogleSignInFirebaseAuth implements BaseAuthenticationService {
  final GoogleSignIn googleSignIn;
  final FirebaseAuth firebaseAuth;
  final CredentialManager credentialManager;

  GoogleSignInFirebaseAuth({
    @required this.googleSignIn,
    @required this.firebaseAuth,
    @required this.credentialManager,
  });

  @override
  Future<FirebaseUser> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

      if (null != googleSignInAccount) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential authCredential = credentialManager.getCredentials(
            googleSignInAuthentication.accessToken, googleSignInAuthentication.idToken);

        AuthResult authResult = await firebaseAuth.signInWithCredential(authCredential);
        return authResult.user;
      }
    } catch (error) {
      print(error.toString());
    }
    return null;
  }

  @override
  Future<GoogleSignInAccount> signOutOfGoogle() async {
    try {
      await firebaseAuth.signOut();
      return await googleSignIn.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}

class CredentialManager {
  AuthCredential getCredentials(String accessToken, String idToken) {
    return GoogleAuthProvider.getCredential(idToken: idToken, accessToken: accessToken);
  }
}
