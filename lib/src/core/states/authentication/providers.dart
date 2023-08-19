part of 'state_notifier.dart';

/// provide access to the authentication notifier
final authenticationProvider = StateNotifierProvider<AuthenticationStateNotifier, AuthenticationStates>(
  (ref) => AuthenticationStateNotifier(ref: ref),
);
