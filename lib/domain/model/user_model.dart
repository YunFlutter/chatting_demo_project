import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_model.freezed.dart';



@freezed
class UserModel with _$UserModel {
  final String phoneNumber;
  final String uuid;

  const UserModel({this.phoneNumber = '', this.uuid = ''});
}
