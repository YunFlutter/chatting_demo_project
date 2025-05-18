import 'package:chatting_demo_project/view/home/home_screen.dart';
import 'package:chatting_demo_project/view/phone_input/phone_input_notifier.dart';
import 'package:chatting_demo_project/view/phone_input/phone_input_screen.dart';
import 'package:chatting_demo_project/view/verify_input/verify_input_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => PhoneInputScreen()),
    GoRoute(path: '/verify', builder: (context, state) => VerifyInputScreen()),
    GoRoute(path: '/home', builder: (context, state) => HomeScreen()),
  ],

  redirect: (BuildContext context, GoRouterState state) async {
    final container = ProviderScope.containerOf(context);
    final phoneInputState = container.read(phoneInputProvider);

    print(state.path);
    print(state.fullPath);

    if (state.path == '/link') {
      return '/verify';
    }

    if (phoneInputState.verifyNumber.isNotEmpty) {
      return '/verify';
    }
    if (phoneInputState.verifyState) {
      return '/home';
    }
    return null;
  },
);
