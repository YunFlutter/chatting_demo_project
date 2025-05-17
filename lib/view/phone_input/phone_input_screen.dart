import 'package:chatting_demo_project/view/phone_input/phone_input_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
                viewModel.inputNumber(phone.completeNumber);
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
              onPressed: () {},
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
