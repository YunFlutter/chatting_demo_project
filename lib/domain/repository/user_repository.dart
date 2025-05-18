import 'package:firebase_auth/firebase_auth.dart';

abstract interface class UserRepository {
  Future<void> saveCreateUser({required UserCredential user});
  Future<bool> getUser({required String phoneNumber});
}