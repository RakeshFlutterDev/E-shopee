import 'package:e_shopee/exceptions/firebaseauth/messeged_firebaseauth_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class FirebaseCredentialActionAuthException
    extends MessagedFirebaseAuthException {
  FirebaseCredentialActionAuthException(String code, String message)
      : super(code, message);

  @override
  AuthCredential? get credential => null;

  @override
  String? get email => null;

  @override
  String? get phoneNumber => null;

  @override
  String? get tenantId => null;

  @override
  String get plugin => 'FlutterFire';

  @override
  StackTrace? get stackTrace => null;
}

class FirebaseCredentialActionAuthUserNotFoundException
    extends FirebaseCredentialActionAuthException {
  FirebaseCredentialActionAuthUserNotFoundException({String message = "No such user exists"})
      : super('user-not-found', message);
}

class FirebaseCredentialActionAuthWeakPasswordException
    extends FirebaseCredentialActionAuthException {
  FirebaseCredentialActionAuthWeakPasswordException({String message = "Password is weak, try something better"})
      : super('weak-password', message);
}

class FirebaseCredentialActionAuthRequiresRecentLoginException
    extends FirebaseCredentialActionAuthException {
  FirebaseCredentialActionAuthRequiresRecentLoginException({String message = "This action requires re-Login"})
      : super('requires-recent-login', message);
}

class FirebaseCredentialActionAuthUnknownReasonFailureException
    extends FirebaseCredentialActionAuthException {
  FirebaseCredentialActionAuthUnknownReasonFailureException({String message = "The action can't be performed due to an unknown reason"})
      : super('unknown-reason', message);
}

class FirebaseReauthWrongPasswordException extends MessagedFirebaseAuthException {
  FirebaseReauthWrongPasswordException()
      : super('reauth-wrong-password', 'Incorrect old password');
}

