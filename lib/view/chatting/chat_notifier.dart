import 'package:chatting_demo_project/data/repository/chat_repository_impl.dart';
import 'package:chatting_demo_project/domain/model/chat_message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatting_demo_project/domain/repository/chat_repository.dart';
import 'package:uuid/uuid.dart';

class ChatViewModel extends Notifier<List<ChatMessage>> {
  late final ChatRepository _chatRepository;
  late String userId1;
  late String userId2;

  @override
  List<ChatMessage> build() {
    _chatRepository = ref.read(chatRepositoryProvider);
    userId1 = ref.read(chatUserId1Provider);
    userId2 = ref.read(chatUserId2Provider);
    _initializeChatHistory();
    _listenToNewMessages();
    return [];
  }

  // 초기 채팅 내역 로드
  Future<void> _initializeChatHistory() async {
    final history = await _chatRepository.fetchChatHistory(userId1, userId2);
    state = history;
  }

  // 새로운 메시지 실시간 수신
  void _listenToNewMessages() {
    _chatRepository.getMessagesStream(userId1, userId2).listen((messages) {
      state = messages;
    });
  }

  // 메시지 전송 (채팅방 자동 생성)
  Future<void> sendMessage(String senderId, String senderName, String message) async {
    final chatMessage = ChatMessage(
      id: const Uuid().v4(),
      senderId: senderId,
      senderName: senderName,
      message: message,
      timestamp: DateTime.now(),
    );

    // 채팅방 생성 여부 체크 후 메시지 전송
    final chatRoomExists = await _chatRepository.isChatRoomExists(userId1, userId2);
    if (!chatRoomExists) {
      await _chatRepository.sendMessage(chatMessage, userId1, userId2);
    } else {
      await _chatRepository.sendMessage(chatMessage, userId1, userId2);
    }
  }
}

final chatUserId1Provider = StateProvider<String>((ref) => '');
final chatUserId2Provider = StateProvider<String>((ref) => '');

final chatProvider = NotifierProvider<ChatViewModel, List<ChatMessage>>(
  ChatViewModel.new,
);