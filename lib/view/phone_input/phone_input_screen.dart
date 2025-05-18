import 'package:chatting_demo_project/view/phone_input/phone_input_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneInputScreen extends ConsumerWidget {
  const PhoneInputScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(phoneInputProvider);
    final viewModel = ref.watch(phoneInputProvider.notifier);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IntlPhoneField(
              decoration: InputDecoration(
                labelText: '핸드폰 번호를 입력해주세요',
                border: OutlineInputBorder(borderSide: BorderSide()),
              ),
              initialCountryCode: "KR",
              onChanged: (phone) {
                viewModel.inputNumber(phone.number);
              },
              languageCode: 'kr',
              countries: [
                Country(
                  name: '대한민국',
                  flag: '🇰🇷',
                  code: 'KR',
                  dialCode: "82",
                  nameTranslations: {},
                  minLength: 11,
                  maxLength: 11,
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                if (RegExp(
                  r'^010-?\d{4}-?\d{4}$',
                ).hasMatch(state.phoneNumber)) {
                  print("await viewModel.userVerify() ${await viewModel.userVerify()}");
                  if(await viewModel.userVerify()){
                    await viewModel.phoneVerify(context: context).then((_) {
                      context.go('/verify');
                    });
                  }else{
                    context.go('/home');
                  }

                } else {
                  print(state.phoneNumber);
                  Fluttertoast.showToast(msg: "올바른 핸드폰 번호를 입력해주세요");
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
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
      ),
    );
  }
}
