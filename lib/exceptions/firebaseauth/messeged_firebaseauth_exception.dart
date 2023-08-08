import 'package:firebase_auth/firebase_auth.dart';

abstract class MessagedFirebaseAuthException implements FirebaseAuthException {
  final String code;
  final String _message;

  MessagedFirebaseAuthException(this.code, this._message);

  String get message => _message;

  @override
  String toString() {
    return message;
  }

  @override
  AuthCredential? get credential => null;

  @override
  String? get email => null;

  @override
  String? get phoneNumber => null;

  @override
  String? get tenantId => null;

  @override
  StackTrace? get stackTrace => null;

  @override
  String get plugin => 'FlutterFire';
}
