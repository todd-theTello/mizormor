import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mizormor/src/core/states/authentication/state_notifier.dart';

import 'config/theme/theme.dart';
import 'firebase_options.dart';
import 'src/core/database/shared_preference.dart';
import 'src/core/states/auth_switcher/provider.dart';
import 'src/core/states/onboarding/states_notifiers.dart';
import 'src/core/states/trips/states_notifiers.dart';
import 'src/core/states/users/states_notifier.dart';
import 'src/ui/views/authentication/register.dart';
import 'src/ui/views/authentication/sign_in.dart';
import 'src/ui/views/navigation_base/main_page.dart';
import 'src/ui/views/onboarding/onboarding.dart';

void main() async {
  await runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await LocalPreference.init();
    final ProviderContainer container = ProviderContainer();
    container.read(onboardingProvider.notifier).checkOnboarding();
    if (LocalPreference.isLoggedIn) {
      await container.read(userStateProvider.notifier).getUserInfo();
      await container.read(userTripStateProvider.notifier).getUserTrips();
      await container.read(tripStateProvider.notifier).getAllTrips();
    }
    container.listen(userStateProvider, (previous, state) async {
      if (state is UserFailure) {
        await container.read(authenticationProvider.notifier).signOut();
      }
    });
    runApp(
      UncontrolledProviderScope(
        container: container,
        child: const ZormorMobileRoot(),
      ),
    );
  }, (error, stack) {});
}

/// This is the root of the Zormor cruiser mobile app
class ZormorMobileRoot extends ConsumerWidget {
  /// Zormor mobile root constructor
  const ZormorMobileRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// watch the theme mode provider for changes to theme
    final theme = ref.watch(themeModeProvider);
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: theme,
      home: const OnboardingSwitcher(),
    );
  }
}

/// switches between onboarding and authentication screen
class OnboardingSwitcher extends ConsumerStatefulWidget {
  /// onboarding switcher constructor

  const OnboardingSwitcher({super.key});

  @override
  ConsumerState createState() => _OnboardingSwitcherState();
}

class _OnboardingSwitcherState extends ConsumerState<OnboardingSwitcher> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(onboardingProvider);

        if (state is IsSignedIn) {
          return const MainPageNavigationWrapper();
        } else if (state is OnboardingIncomplete || state is OnboardingInitial) {
          return const OnboardingView();
        } else {
          return const AuthSwitcher();
        }
      },
    );
  }
}

///
class AuthSwitcher extends ConsumerWidget {
  ///
  const AuthSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authSwitcherProvider);
    return state ? const SignInView() : const RegistrationView();
  }
}
