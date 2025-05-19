import 'package:chatting_demo_project/domain/model/chat_send_model.dart';
import 'package:chatting_demo_project/view/home/home_notifier.dart';
import 'package:chatting_demo_project/domain/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('홈 스크린'), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child:
                state.userList.isEmpty
                    ? const Center(child: Text('유저가 없습니다.'))
                    : ListView.builder(
                      itemCount: state.userList.length,
                      itemBuilder: (context, index) {
                        final user = state.userList[index];
                        return ListTile(
                          title: Text(user.phoneNumber),
                          leading: const Icon(Icons.account_circle),
                          trailing: IconButton(
                            icon: const Icon(Icons.message),
                            onPressed: () {
                              context.push(
                                '/chat',
                                extra: ChatSendModel(
                                  sendUserId: user.uuid,
                                  currentUserId: state.currentUser.uuid,
                                  sendName: state.currentUser.phoneNumber,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
