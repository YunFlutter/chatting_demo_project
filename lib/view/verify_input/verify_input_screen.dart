import 'package:chatting_demo_project/data/repository/user_repository_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../phone_input/phone_input_notifier.dart';

class VerifyInputScreen extends ConsumerWidget {
  const VerifyInputScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(phoneInputProvider);
    final viewModel = ref.watch(phoneInputProvider.notifier);
    final userSave = ref.read(userRepositoryProvider);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          OtpTextField(
            numberOfFields: 6,

            borderColor: Color(0xFF512DA8),
            //set to true to show as box or false to show as dash
            showFieldAsBox: true,
            //runs when a code is typed in
            onCodeChanged: (String code) {},
            //runs when every textfield is filled
            onSubmit: (String verificationCode) {
              viewModel.userVerifyNumber(verificationCode);
            }, // end onSubmit
          ),
          ElevatedButton(
            onPressed: () async {
              final PhoneAuthCredential
              credential = PhoneAuthProvider.credential(
                verificationId:
                    state
                        .verifyNumber, // verifyPhoneNumber() 메서드에서 받은 verificationId
                smsCode: state.userVerifyNumber, // 사용자가 입력한 SMS 코드
              );
              final userCreate = await viewModel.createUser(
                credential: credential,
              );
              await userSave.saveCreateUser(user: userCreate).then((_) {
                context.go('/home');
              });
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text("인증번호 전송하기"),
          ),
        ],
      ),
    );
  }
}
