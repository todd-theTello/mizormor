import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../bus/search.dart';
import '../home/home.dart';
import '../profile/profile.dart';
import '../trips/trips.dart';

/// main home navigation with pages
class MainPageNavigationWrapper extends ConsumerStatefulWidget {
  /// main page view constructor
  const MainPageNavigationWrapper({super.key});

  @override
  ConsumerState createState() => _MainPageViewState();
}

class _MainPageViewState extends ConsumerState<MainPageNavigationWrapper> {
  /// define the list of pages to show in the navigator
  final List<Widget> pageDestinations = <Widget>[
    const HomeView(),
    const TripsView(),
    const SearchBusView(),
    const ProfileView(),
  ];

  /// Initialize the current page index to 0
  int currentPageIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Iconsax.home),
            selectedIcon: Icon(Iconsax.home_15),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.clock),
            selectedIcon: Icon(Iconsax.clock5),
            label: 'My Trips',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.car),
            selectedIcon: Icon(Iconsax.car5),
            label: 'Buses',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.user),
            selectedIcon: Icon(Iconsax.profile_circle5),
            label: 'Profile',
          ),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
      ),
      body: IndexedStack(index: currentPageIndex, children: pageDestinations),
    );
  }
}
