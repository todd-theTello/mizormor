import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/extensions/object/log.dart';
import '../../database/shared_preference.dart';

part 'provider.dart';
part 'states.dart';

/// Onboarding state
class OnboardingStateNotifier extends StateNotifier<OnboardingStates> {
  ///
  OnboardingStateNotifier() : super(OnboardingInitial());

  /// check the onboarding state depending on the value from local db
  void checkOnboarding() {
    if (LocalPreference.isLoggedIn) {
      state = IsSignedIn();
    } else if (LocalPreference.hasOnboarded) {
      state = OnboardingComplete();
    } else {
      state = OnboardingIncomplete();
    }
  }

  /// set the the value on onboarded to true
  Future<void> setOnboarded() async {
    await LocalPreference.writeBoolToStorage(key: LocalPreference.KEY_ON_BOARDED, value: true);
    checkOnboarding();
  }

  /// set the the value on onboarded to true
  Future<void> setLoggedIn() async {
    await LocalPreference.writeBoolToStorage(key: LocalPreference.KEY_IS_LOGIN, value: true);
    checkOnboarding();
    LocalPreference.isLoggedIn.log();
  }

  /// set the the value on onboarded to true
  Future<void> setLogOut() async {
    await LocalPreference.writeBoolToStorage(key: LocalPreference.KEY_IS_LOGIN, value: false);
    checkOnboarding();
    LocalPreference.isLoggedIn.log();
  }
}
