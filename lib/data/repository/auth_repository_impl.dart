import 'package:chatting_demo_project/domain/repository/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.startsWith("0")) {
      // "01012345678" -> "+821012345678"
      return "+82${phoneNumber.substring(1)}";
    }
    return phoneNumber;
  }

  @override
  Future<String> verifyPhoneNumber({
    required String phoneNumber,
    required Function() onVerificationCompleted,
    required Function(String errorMessage) onError,
    required Function(String id, int? resendToken) codeSent,
    required Function(String verificationId) onAutoRetrievalTimeout,
  }) async {


    try {
      String verificationId = '';
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: formatPhoneNumber(phoneNumber),
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _firebaseAuth.signInWithCredential(credential);
          onVerificationCompleted();
        },
        verificationFailed: (FirebaseAuthException e) {
          print('error $e');
        },
        codeSent: (String id, int? resendToken) {
          print("코드 보내기 성공");
          verificationId = id;
          codeSent(id, resendToken);
        },
        codeAutoRetrievalTimeout: (String id) {
          onAutoRetrievalTimeout(id);
        },
      );
      return verificationId;
    } catch (e) {
      onError(e.toString());
      return '';
    }
  }

  @override
  Future<UserCredential> signInPhoneNumber({
    required PhoneAuthCredential credential,
  }) async {
    final data = await _firebaseAuth.signInWithCredential(credential);
    return data;
  }

}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(firebaseAuth: FirebaseAuth.instance);
});
