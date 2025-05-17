import 'package:chatting_demo_project/view/phone_input/phone_input_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PhoneInputNotifier extends Notifier<PhoneInputState> {
  @override
  PhoneInputState build() => PhoneInputState();

  void initNumber() => state.copyWith(phoneNumber: '');
  void inputNumber(String number) => state.copyWith(phoneNumber: number);

}

final phoneInputProvider =
    NotifierProvider<PhoneInputNotifier, PhoneInputState>(
      () => PhoneInputNotifier(),
    );
