import 'package:chatting_demo_project/domain/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class UserRepository {
  Future<void> saveCreateUser({required UserCredential user});
  Future<bool> getUser({required String phoneNumber});
  Future<UserModel> getUserModel({required String phoneNumber});
  Future<List<UserModel>> getUserList({required String phoneNumber});
}