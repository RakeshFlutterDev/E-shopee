
import 'package:e_shopee/exceptions/firebaseauth/messeged_firebaseauth_exception.dart';

class FirebaseReauthException extends MessagedFirebaseAuthException {
  FirebaseReauthException({String code = "reauth-exception", String message = "Instance of FirebaseReauthException"})
      : super(code, message);
}

class FirebaseReauthUserMismatchException extends FirebaseReauthException {
  FirebaseReauthUserMismatchException({String message = "User not matching with current user"})
      : super(code: "user-mismatch", message: message);
}

class FirebaseReauthUserNotFoundException extends FirebaseReauthException {
  FirebaseReauthUserNotFoundException({String message = "No such user exists"})
      : super(code: "user-not-found", message: message);
}

class FirebaseReauthInvalidCredentialException extends FirebaseReauthException {
  FirebaseReauthInvalidCredentialException({String message = "Invalid Credentials"})
      : super(code: "invalid-credential", message: message);
}

class FirebaseReauthInvalidEmailException extends FirebaseReauthException {
  FirebaseReauthInvalidEmailException({String message = "Invalid Email"})
      : super(code: "invalid-email", message: message);
}

class FirebaseReauthWrongPasswordException extends FirebaseReauthException {
  FirebaseReauthWrongPasswordException({String message = "Wrong password"})
      : super(code: "wrong-password", message: message);
}

class FirebaseReauthInvalidVerificationCodeException
    extends FirebaseReauthException {
  FirebaseReauthInvalidVerificationCodeException({String message = "Invalid Verification Code"})
      : super(code: "invalid-verification-code", message: message);
}

class FirebaseReauthInvalidVerificationIdException
    extends FirebaseReauthException {
  FirebaseReauthInvalidVerificationIdException({String message = "Invalid Verification ID"})
      : super(code: "invalid-verification-id", message: message);
}

class FirebaseReauthUnknownReasonFailureException
    extends FirebaseReauthException {
  FirebaseReauthUnknownReasonFailureException({String message = "Reauthentication Failed due to unknown reason"})
      : super(code: "unknown-reason", message: message);
}
