import 'package:chatting_demo_project/view/chatting/chat_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isLoadingProvider = StateProvider<bool>((ref) => true);

class ChatScreen extends ConsumerStatefulWidget {
  final String currentUserId;
  final String otherUserId;
  final String senderName;

  const ChatScreen({
    super.key,
    required this.currentUserId,
    required this.otherUserId,
    required this.senderName,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // 초기화 로직을 지연하여 실행 (빌드 완료 후)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatUserId1Provider.notifier).state = widget.currentUserId;
      ref.read(chatUserId2Provider.notifier).state = widget.otherUserId;

      // 로딩 상태 초기화
      ref.read(isLoadingProvider.notifier).state = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider);
    final isLoading = ref.watch(isLoadingProvider);

    // 로딩 상태 해제 (빌드 중 상태 수정 방지)
    if (isLoading && messages.isNotEmpty) {
      Future.microtask(() {
        ref.read(isLoadingProvider.notifier).state = false;
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.senderName)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : messages.isNotEmpty
                  ? ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isMine = message.senderId == widget.currentUserId;
                  return Align(
                    alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isMine ? Colors.blue : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        message.message,
                        style: TextStyle(
                          color: isMine ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              )
                  : const Center(
                child: Text(
                  "빈 메시지 창",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(hintText: 'Enter your message...'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      final message = _messageController.text.trim();
                      if (message.isNotEmpty) {
                        ref.read(chatProvider.notifier).sendMessage(
                          widget.currentUserId,
                          widget.senderName,
                          message,
                        );
                        _messageController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}