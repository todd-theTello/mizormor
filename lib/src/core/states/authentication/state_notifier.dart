import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mizormor/src/core/states/trips/states_notifiers.dart';
import 'package:mizormor/src/core/states/users/states_notifier.dart';

import '../../database/shared_preference.dart';
import '../../model/login_request_data.dart';
import '../../repository/repositories.dart';
import '../onboarding/states_notifiers.dart';

part 'providers.dart';
part 'states.dart';

/// authentication states notifiers
class AuthenticationStateNotifier extends StateNotifier<AuthenticationStates> {
  /// initialize authentication state notifier with the initial authentication state
  AuthenticationStateNotifier({required this.ref}) : super(AuthenticationInitial());
  final AuthenticationRepository _authenticationRepository = AuthenticationRepository();
  final Ref ref;

  /// perform email sign in
  Future<void> emailSignIn({required String email, required String password}) async {
    try {
      /// Set authentication state to loading
      state = AuthenticationLoading();

      /// attempt login with firebase via authentication repository
      final response = await _authenticationRepository.signInWithEmail(email: email, password: password);

      /// check if login attempt was successful
      if (response.status) {
        /// write user ID to local storage
        await LocalPreference.writeStringToStorage(
          key: LocalPreference.KEY_USER_ID,
          value: response.data!,
        );

        /// Set onboarding state state to onboarded
        await ref.read(onboardingProvider.notifier).setLoggedIn();
        ref.read(userStateProvider.notifier).getUserInfo();
        ref.read(tripStateProvider.notifier).getAllTrips();
        ref.read(userTripStateProvider.notifier).getUserTrips();

        /// fetch main page data if authentication is successful
        // await ref.read(mainPageStateProvider.notifier).fetchUserInfo();

        /// set authentication state to success afterwards
        state = AuthenticationSuccess();
      } else {
        /// set authentication state to failure if login attempt is unsuccessful
        state = AuthenticationFailure(error: response.message);
      }
    } catch (err) {
      /// set authentication state to failure if an unknown error occurs
      state = AuthenticationFailure(error: err.toString());
    }
  }

  /// perform email registration
  Future<void> emailRegistration({required RegistrationRequestData data}) async {
    try {
      /// Set authentication state to loading
      state = AuthenticationLoading();

      /// attempt login with firebase via authentication repository
      final response = await _authenticationRepository.registerWithEmail(data: data);

      /// check if login attempt was successful
      if (response.status) {
        /// write user ID to local storage
        await LocalPreference.writeStringToStorage(key: LocalPreference.KEY_USER_ID, value: response.data!);

        /// Set onboarding state state to onboarded
        await ref.read(onboardingProvider.notifier).setLoggedIn();
        ref.read(userStateProvider.notifier).getUserInfo();
        ref.read(tripStateProvider.notifier).getAllTrips();
        ref.read(userTripStateProvider.notifier).getUserTrips();

        /// fetch main page data if authentication is successful
        // await ref.read(mainPageStateProvider.notifier).fetchUserInfo();

        /// set authentication state to success afterwards
        state = AuthenticationSuccess();
      } else {
        /// set authentication state to failure if login attempt is unsuccessful
        state = AuthenticationFailure(error: response.message);
      }
    } catch (err) {
      /// set authentication state to failure if an unknown error occurs
      state = AuthenticationFailure(error: err.toString());
    }
  }

  /// Handles google login authentication action

  Future<void> googleSignIn() async {
    try {
      /// Set authentication state to loading
      state = AuthenticationLoading();

      /// attempt login with firebase via authentication repository
      final response = await _authenticationRepository.googleSignIn();

      /// check if login attempt was successful
      if (response.status) {
        /// write user ID to local storage
        await LocalPreference.writeStringToStorage(
          key: LocalPreference.KEY_USER_ID,
          value: response.data!,
        );

        /// Set onboarding state state to onboarded
        await ref.read(onboardingProvider.notifier).setLoggedIn();
        ref.read(userStateProvider.notifier).getUserInfo();
        ref.read(tripStateProvider.notifier).getAllTrips();
        ref.read(userTripStateProvider.notifier).getUserTrips();

        /// fetch main page data if authentication is successful
        // await ref.read(mainPageStateProvider.notifier).fetchUserInfo();

        /// set authentication state to success afterwards
        state = AuthenticationSuccess();
      } else {
        /// set authentication state to failure if login attempt is unsuccessful
        state = AuthenticationFailure(error: response.message);
      }
    } catch (err) {
      /// set authentication state to failure if an unknown error occurs
      state = AuthenticationFailure(error: err.toString());
    }
  }

  Future<void> appleSignIn() async {
    try {
      /// Set authentication state to loading
      state = AuthenticationLoading();

      /// attempt login with firebase via authentication repository
      final response = await _authenticationRepository.signInWithApple();

      /// check if login attempt was successful
      if (response.status) {
        /// write user ID to local storage
        await LocalPreference.writeStringToStorage(
          key: LocalPreference.KEY_USER_ID,
          value: response.data!,
        );

        /// Set onboarding state state to onboarded
        await ref.read(onboardingProvider.notifier).setLoggedIn();
        ref.read(userStateProvider.notifier).getUserInfo();
        ref.read(userTripStateProvider.notifier).getUserTrips();
        ref.read(tripStateProvider.notifier).getAllTrips();

        /// fetch main page data if authentication is successful
        // await ref.read(mainPageStateProvider.notifier).fetchUserInfo();

        /// set authentication state to success afterwards
        state = AuthenticationSuccess();
      } else {
        /// set authentication state to failure if login attempt is unsuccessful
        state = AuthenticationFailure(error: response.message);
      }
    } catch (err) {
      /// set authentication state to failure if an unknown error occurs
      state = AuthenticationFailure(error: err.toString());
    }
  }

  Future<void> signOut() async {
    state = AuthenticationLoading();
    await _authenticationRepository.signOut();
    await ref.read(onboardingProvider.notifier).setLogOut();
    state = AuthenticationLogoutSuccess();
  }

  Future<void> forgotPassword({required String email}) async {
    state = AuthenticationLoading();
    final response = await _authenticationRepository.forgotPassword(email: email);
    if (response.status) {
      state = AuthenticationForgotPasswordSuccess();
    } else {
      state = AuthenticationForgotPasswordFailure(error: response.message);
    }
  }
}
