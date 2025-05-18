import 'package:firebase_auth/firebase_auth.dart';

abstract interface class AuthRepository {
  Future<String> verifyPhoneNumber({
    required String phoneNumber,

    required Function() onVerificationCompleted,
    required Function(String errorMessage) onError,
    required Function(String id, int? resendToken) codeSent,
    required Function(String verificationId) onAutoRetrievalTimeout,
  });

  Future<UserCredential> signInPhoneNumber({
    required PhoneAuthCredential credential,
  });
}