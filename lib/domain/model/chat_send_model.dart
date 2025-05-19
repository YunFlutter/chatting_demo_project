import 'package:freezed_annotation/freezed_annotation.dart';
part 'chat_send_model.freezed.dart';

@freezed
class ChatSendModel with _$ChatSendModel {
  final String currentUserId;
  final String sendUserId;
  final String sendName;

  const ChatSendModel({
    this.currentUserId = '',
    this.sendUserId = '',
    this.sendName = '',
  });
}
