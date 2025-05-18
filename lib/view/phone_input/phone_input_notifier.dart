import 'package:chatting_demo_project/data/repository/auth_repository_impl.dart';
import 'package:chatting_demo_project/data/repository/user_repository_impl.dart';
import 'package:chatting_demo_project/domain/repository/auth_repository.dart';
import 'package:chatting_demo_project/domain/repository/user_repository.dart';
import 'package:chatting_demo_project/view/phone_input/phone_input_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class PhoneInputNotifier extends Notifier<PhoneInputState> {
  late final AuthRepository _authRepository;
  late final UserRepository _userRepository;

  @override
  PhoneInputState build() {
    _authRepository = ref.read(authRepositoryProvider);
    _userRepository = ref.read(userRepositoryProvider);
    return PhoneInputState();
  }

  void initNumber() => state = state.copyWith(phoneNumber: '');

  void inputNumber(String number) =>
      state = state.copyWith(phoneNumber: number);

  void userVerifyNumber(String number) =>
      state = state.copyWith(userVerifyNumber: number);

  Future<bool> userVerify() async{
    final bool response = await _userRepository.getUser(phoneNumber: state.phoneNumber);
    return response;
  }

  Future<void> phoneVerify({required BuildContext context}) async {

    final response = await _authRepository.verifyPhoneNumber(
      phoneNumber: state.phoneNumber,
      onVerificationCompleted: () {
        Fluttertoast.showToast(msg: '회원가입 성공! 홈 화면으로 이동합니다!');
      },
      onError: (errorMessage) {
        Fluttertoast.showToast(msg: errorMessage);
        state = state.copyWith(verifyNumber: '', verifyState: false);
      },
      onAutoRetrievalTimeout: (verificationId) {
        Fluttertoast.showToast(
          msg: '시간이 초과 되었습니다. 다시 핸드폰 번호를 입력하시고 인증번호를 발송해주세요',
        );
        state = state.copyWith(verifyNumber: '', verifyState: false);
      },
      codeSent: (id, resendToken) {
        state = state.copyWith(verifyNumber: id);
      },
    );

    state = state.copyWith(verifyNumber: response);
  }

  Future<UserCredential> createUser({
    required PhoneAuthCredential credential,
  }) async {
    final response = await _authRepository.signInPhoneNumber(
      credential: credential,
    );
    return response;
  }
}

final phoneInputProvider =
    NotifierProvider<PhoneInputNotifier, PhoneInputState>(
      PhoneInputNotifier.new,
    );
