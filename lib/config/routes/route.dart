import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../main.dart';
import '../../src/ui/views/authentication/register.dart';
import '../../src/ui/views/authentication/sign_in.dart';
import '../../src/ui/views/bus/search.dart';
import '../../src/ui/views/navigation_base/main_page.dart';

/// create a provider to access the go router configuration
final goRouterProvider = Provider<GoRouter>(
  (ref) {
    // final router = RouteNotifier(ref);
    return GoRouter(
      initialLocation: '/',
      // refreshListenable: router,
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const OnboardingSwitcher(),
        ),
        GoRoute(
          path: '/sign_in',
          builder: (context, state) => const SignInView(),
        ),
        GoRoute(
          path: '/authentication',
          builder: (context, state) => const AuthSwitcher(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegistrationView(),
        ),
        GoRoute(
          path: '/main',
          builder: (context, state) => const MainPageNavigationWrapper(),
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => const SearchBusView(),
        ),
        // GoRoute(
        //   path: '/trip-summary',
        //   builder: (context, state) => TripSummaryView(trip: state.extra! as Trips),
        // ),
        GoRoute(
          path: '/ticket',
          builder: (context, state) => const SearchBusView(),
        ),

        // GoRoute(
        //   path: '/search',
        //   builder: (context, state) => const SearchBusView(),
        // ),
      ],
    );
  },
);
