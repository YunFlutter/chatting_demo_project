import 'package:chatting_demo_project/data/repository/user_repository_impl.dart';
import 'package:chatting_demo_project/domain/repository/user_repository.dart';
import 'package:chatting_demo_project/view/home/home_state.dart';
import 'package:chatting_demo_project/view/phone_input/phone_input_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeNotifier extends Notifier<HomeState> {
  late UserRepository _userRepository;

  @override
  HomeState build() {
    _userRepository = ref.read(userRepositoryProvider);

    final userState = ref.watch(phoneInputProvider);
    if (userState.phoneNumber.isNotEmpty) {
      fetchUserList(userState.phoneNumber);
      userInit(phoneNumber: userState.phoneNumber);
    }

    return HomeState();
  }

  Future<void> fetchUserList(String phoneNumber) async {
    try {
      final userList = await _userRepository.getUserList(
        phoneNumber: phoneNumber,
      );
      state = state.copyWith(userList: userList);
    } catch (e) {
      print("Error fetching user list: $e");
    }
  }

  Future<void> userInit({required String phoneNumber}) async {
    final response = await _userRepository.getUserModel(
      phoneNumber: phoneNumber,
    );
    state = state.copyWith(currentUser: response);
  }

  void chatInit({required String sendUserId}) {
    state = state.copyWith(
      sendModel: state.sendModel.copyWith(
        currentUserId: state.currentUser.uuid,
        sendUserId: sendUserId,
      ),
    );
  }
}

final homeProvider = NotifierProvider<HomeNotifier, HomeState>(
  () => HomeNotifier(),
);
