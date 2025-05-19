import 'package:chatting_demo_project/domain/model/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatting_demo_project/domain/repository/chat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatRepositoryImpl implements ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  String generateChatRoomId(String userId1, String userId2) {
    final sortedIds = [userId1, userId2]..sort();
    return sortedIds.join('_');
  }

  @override
  Future<void> sendMessage(ChatMessage message, String userId1, String userId2) async {
    final chatRoomId = generateChatRoomId(userId1, userId2);
    final chatRoomRef = _firestore.collection('chat_rooms').doc(chatRoomId);
    final messageRef = chatRoomRef.collection('messages').doc(message.id);

    // 채팅방이 없을 경우 생성
    final chatRoomDoc = await chatRoomRef.get();
    if (!chatRoomDoc.exists) {
      await chatRoomRef.set({
        'chatRoomId': chatRoomId,
        'users': [userId1, userId2],
        'createdAt': DateTime.now(),
      });
    }

    // 메시지 저장
    await messageRef.set(message.toJson());
  }

  @override
  Stream<List<ChatMessage>> getMessagesStream(String userId1, String userId2) {
    final chatRoomId = generateChatRoomId(userId1, userId2);
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ChatMessage.fromJson(doc.data()))
        .toList());
  }

  @override
  Future<List<ChatMessage>> fetchChatHistory(String userId1, String userId2) async {
    final chatRoomId = generateChatRoomId(userId1, userId2);
    final snapshot = await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .get();

    return snapshot.docs
        .map((doc) => ChatMessage.fromJson(doc.data()))
        .toList();
  }

  @override
  // 채팅방 존재 여부 체크
  Future<bool> isChatRoomExists(String userId1, String userId2) async {
    final chatRoomId = generateChatRoomId(userId1, userId2);
    final chatRoomDoc = await _firestore.collection('chat_rooms').doc(chatRoomId).get();
    return chatRoomDoc.exists;
  }
}
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl();
});