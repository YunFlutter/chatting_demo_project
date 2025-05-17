
import 'package:freezed_annotation/freezed_annotation.dart';
part 'phone_input_state.freezed.dart';


@freezed
class PhoneInputState with _$PhoneInputState {
  final String phoneNumber;

  const PhoneInputState({
     this.phoneNumber = '',
  });
}