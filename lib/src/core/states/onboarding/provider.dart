part of 'states_notifiers.dart';

///
final onboardingProvider = StateNotifierProvider<OnboardingStateNotifier, OnboardingStates>(
  (_) => OnboardingStateNotifier(),
);
