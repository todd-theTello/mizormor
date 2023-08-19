part of 'states_notifier.dart';

/// user state notifier provider
final userStateProvider = StateNotifierProvider<UserStateNotifier, UserStates>(
  (ref) => UserStateNotifier(),
);
