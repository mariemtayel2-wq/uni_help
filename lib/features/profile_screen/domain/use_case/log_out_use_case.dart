import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LogoutUseCase {
  const LogoutUseCase(this._auth);
  final FirebaseAuth _auth;
  Future<void> call() => _auth.signOut();
}