import 'package:chatting_demo_project/domain/model/user_model.dart';
import 'package:chatting_demo_project/domain/repository/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firebaseFirestore;

  const UserRepositoryImpl({required FirebaseFirestore firebaseFirestore})
    : _firebaseFirestore = firebaseFirestore;

  String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.startsWith("0")) {
      // "01012345678" -> "+821012345678"
      return "+82${phoneNumber.substring(1)}";
    }
    return phoneNumber;
  }

  @override
  Future<void> saveCreateUser({required UserCredential user}) async {
    await _firebaseFirestore.collection('user').doc(user.user!.uid).set({
      'phone': user.user!.phoneNumber,
      'uuid': user.user!.uid,
    });

    Fluttertoast.showToast(msg: '회원가입 성공!');
  }

  @override
  Future<bool> getUser({required String phoneNumber}) async{
    final response = await _firebaseFirestore.collection('user').where('phone', isEqualTo: formatPhoneNumber(phoneNumber)).get();
    return response.docs.isEmpty;
  }

  @override
  Future<List<UserModel>> getUserList({required String phoneNumber}) async{
    final response = await _firebaseFirestore.collection('user').where('phone', isNotEqualTo: formatPhoneNumber(phoneNumber)).get();
    return response.docs.map((items) => UserModel(phoneNumber: items["phone"], uuid: items["uuid"])).toList();
  }


}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(firebaseFirestore: FirebaseFirestore.instance);
});