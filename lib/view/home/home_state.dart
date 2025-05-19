import 'package:chatting_demo_project/domain/model/chat_send_model.dart';
import 'package:chatting_demo_project/domain/model/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  final List<UserModel> userList;
  final UserModel currentUser;
  final ChatSendModel sendModel;

  const HomeState({
    this.userList = const [],
    this.currentUser = const UserModel(),
    this.sendModel = const ChatSendModel(),
  });
}
