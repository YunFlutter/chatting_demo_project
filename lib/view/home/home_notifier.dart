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
    return HomeState();
  }

  Future<void> fetchUserList() async {
    final userState = ref.read(phoneInputProvider);
    state = state.copyWith(userList: await _userRepository.getUserList(phoneNumber: userState.phoneNumber));
  }
}
