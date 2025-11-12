import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService({required this.firebaseAuth});

  final FirebaseAuth firebaseAuth;

  Future<UserCredential>? _signInFuture;

  Future<String> authenticate() async {
    final credential = await _signInUser();
    final accessToken = await credential.user?.getIdToken();
    if (accessToken == null) {
      throw AuthServiceError.firebaseTokenMissing;
    }
    return accessToken;
  }

  Future<void> invalidate() async {
    await firebaseAuth.signOut();
  }

  Future<UserCredential> _signInUser() {
    if (_signInFuture case var signInFuture?) {
      return signInFuture;
    }

    final signInFuture = firebaseAuth.signInAnonymously();

    _signInFuture = signInFuture.whenComplete(() {
      _signInFuture = null;
    });

    return signInFuture;
  }
}

enum AuthServiceError { firebaseTokenMissing }
