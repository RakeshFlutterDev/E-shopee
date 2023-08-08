
import 'package:e_shopee/exceptions/firebaseauth/messeged_firebaseauth_exception.dart';

class FirebaseSignInAuthException extends MessagedFirebaseAuthException {
  FirebaseSignInAuthException({String code = "sign-in-auth-exception", String message = "Instance of FirebaseSignInAuthException"})
      : super(code, message);
}

class FirebaseSignInAuthUserDisabledException extends FirebaseSignInAuthException {
  FirebaseSignInAuthUserDisabledException({String message = "This user is disabled"})
      : super(code: "user-disabled", message: message);
}

class FirebaseSignInAuthUserNotFoundException extends FirebaseSignInAuthException {
  FirebaseSignInAuthUserNotFoundException({String message = "User not found"})
      : super(code: "user-not-found", message: message);
}

class FirebaseSignInAuthInvalidEmailException extends FirebaseSignInAuthException {
  FirebaseSignInAuthInvalidEmailException({String message = "Email is not valid"})
      : super(code: "invalid-email", message: message);
}

class FirebaseSignInAuthWrongPasswordException extends FirebaseSignInAuthException {
  FirebaseSignInAuthWrongPasswordException({String message = "Wrong password"})
      : super(code: "wrong-password", message: message);
}

class FirebaseTooManyRequestsException extends FirebaseSignInAuthException {
  FirebaseTooManyRequestsException({String message = "Server busy, Please try again after some time."})
      : super(code: "too-many-requests", message: message);
}

class FirebaseSignInAuthUserNotVerifiedException extends FirebaseSignInAuthException {
  FirebaseSignInAuthUserNotVerifiedException({String message = "This user is not verified"})
      : super(code: "user-not-verified", message: message);
}

class FirebaseSignInAuthUnknownReasonFailure extends FirebaseSignInAuthException {
  FirebaseSignInAuthUnknownReasonFailure({String message = "Sign in failed due to unknown reason"})
      : super(code: "unknown-reason", message: message);
}
