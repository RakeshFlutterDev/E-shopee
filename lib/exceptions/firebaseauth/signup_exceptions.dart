
import 'package:e_shopee/exceptions/firebaseauth/messeged_firebaseauth_exception.dart';

class FirebaseSignUpAuthException extends MessagedFirebaseAuthException {
  FirebaseSignUpAuthException({String code = "sign-up-auth-exception", String message = "Instance of FirebaseSignUpAuthException"})
      : super(code, message);
}

class FirebaseSignUpAuthEmailAlreadyInUseException extends FirebaseSignUpAuthException {
  FirebaseSignUpAuthEmailAlreadyInUseException({String message = "Email already in use"})
      : super(code: "email-already-in-use", message: message);
}

class FirebaseSignUpAuthInvalidEmailException extends FirebaseSignUpAuthException {
  FirebaseSignUpAuthInvalidEmailException({String message = "Email is not valid"})
      : super(code: "invalid-email", message: message);
}

class FirebaseSignUpAuthOperationNotAllowedException extends FirebaseSignUpAuthException {
  FirebaseSignUpAuthOperationNotAllowedException({String message = "Sign up is restricted for this user"})
      : super(code: "operation-not-allowed", message: message);
}

class FirebaseSignUpAuthWeakPasswordException extends FirebaseSignUpAuthException {
  FirebaseSignUpAuthWeakPasswordException({String message = "Weak password, try something better"})
      : super(code: "weak-password", message: message);
}

class FirebaseSignUpAuthUnknownReasonFailureException extends FirebaseSignUpAuthException {
  FirebaseSignUpAuthUnknownReasonFailureException({String message = "Can't register due to unknown reason"})
      : super(code: "unknown-reason", message: message);
}
