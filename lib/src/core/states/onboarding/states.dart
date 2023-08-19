part of 'states_notifiers.dart';

/// Abstraction on onboarding states
abstract interface class OnboardingStates extends Equatable {}

/// Initial onboarding state
class OnboardingInitial extends OnboardingStates {
  @override
  List<Object?> get props => [];
}

/// Onboarding complete state
class OnboardingComplete extends OnboardingStates {
  @override
  List<Object?> get props => [];
}

/// Not onboarded state
class OnboardingIncomplete extends OnboardingStates {
  @override
  List<Object?> get props => [];
}

///  onboarding state of a signed in user
class IsSignedIn extends OnboardingStates {
  @override
  List<Object?> get props => [];
}
