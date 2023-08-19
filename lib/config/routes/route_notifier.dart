import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../src/core/states/onboarding/states_notifiers.dart';

///
class RouteNotifier extends ChangeNotifier {
  ///
  RouteNotifier(this._ref) {
    _ref.listen<OnboardingStates>(
      onboardingProvider,
      (_, __) => notifyListeners(),
    );
  }
  final Ref _ref;

  ///
  String? redirectLogic(BuildContext context, GoRouterState state) {
    final routeState = _ref.watch(onboardingProvider);
    if (routeState is IsSignedIn) {
      return '/main';
    } else if (routeState is OnboardingIncomplete || state is OnboardingInitial) {
      return '/';
    } else {
      return '/authentication';
    }
  }
}
