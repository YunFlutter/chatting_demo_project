import 'package:freezed_annotation/freezed_annotation.dart';
part 'phone_input_state.freezed.dart';

@freezed
class PhoneInputState with _$PhoneInputState {
  final String phoneNumber;
  final String verifyNumber;
  final String userVerifyNumber;
  final bool verifyState;

  const PhoneInputState({
    this.phoneNumber = '',
    this.verifyNumber = '',
    this.userVerifyNumber = '',
    this.verifyState = false,
  });
}
