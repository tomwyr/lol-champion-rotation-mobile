import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService({
    required this.firebaseAuth,
  });

  final FirebaseAuth firebaseAuth;

  Future<String> authenticate() async {
    final credential = await firebaseAuth.signInAnonymously();
    final accessToken = await credential.user?.getIdToken();
    if (accessToken == null) {
      throw AuthServiceError.firebaseTokenMissing;
    }
    return accessToken;
  }
}

enum AuthServiceError {
  firebaseTokenMissing,
}
