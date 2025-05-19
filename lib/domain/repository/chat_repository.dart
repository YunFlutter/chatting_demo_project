import 'package:chatting_demo_project/domain/model/chat_message.dart';

abstract class ChatRepository {
  // UUID로 채팅방 ID 생성
  String generateChatRoomId(String userId1, String userId2);

  // 메시지 전송
  Future<void> sendMessage(ChatMessage message, String userId1, String userId2);

  // 메시지 스트림
  Stream<List<ChatMessage>> getMessagesStream(String userId1, String userId2);

  // 초기 채팅 내역
  Future<List<ChatMessage>> fetchChatHistory(String userId1, String userId2);

  Future<bool> isChatRoomExists(String userId1, String userId2);
}
