import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mizormor/src/core/states/auth_switcher/provider.dart';
import 'package:mizormor/utils/extensions/padding.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/states/onboarding/states_notifiers.dart';
import 'elements/onboarding_components.dart';

/// Page controller to control page scroll and activities
final pageController = Provider((ref) => PageController());

/// Main onboarding page
class OnboardingView extends ConsumerStatefulWidget {
  /// Onboarding page constructor
  const OnboardingView({super.key});

  @override
  ConsumerState createState() => _OnboardingViewState();
}

class _OnboardingViewState extends ConsumerState<OnboardingView> {
  /// Define the current page number, initialized to 1
  /// This will mainly be used to switch the buttons on the page
  int currentPageNumber = 1;

  /// a void integer function to assign on page changed in PageView builder
  void Function(int)? onPageChanged(int index) {
    setState(() {
      currentPageNumber = index + 1;
    });
    if (kDebugMode) {
      print(currentPageNumber);
    }
    return null;
  }

  /// List of pages or widgets to display in PageView builder
  final List<Widget> pages = const <Widget>[PageOne(), PageTwo(), PageThree()];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            /// Wrap PageView builder in Expanded to prevent overflow
            Expanded(
                child: PageView.builder(
              physics: const BouncingScrollPhysics(),
              controller: ref.watch(pageController),
              onPageChanged: onPageChanged,
              itemCount: 3,
              itemBuilder: (context, index) => pages[index],
            )),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 38, 24, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SmoothPageIndicator(
                  controller: ref.watch(pageController),
                  count: 3,
                  effect: ExpandingDotsEffect(
                    activeDotColor: Theme.of(context).primaryColor,
                    dotColor: Theme.of(context).primaryColor.withOpacity(0.42),
                    dotHeight: 10,
                    offset: 24,
                    dotWidth: 10,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 68),
              child: currentPageNumber == 3
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              await ref.read(onboardingProvider.notifier).setOnboarded();
                            },
                            child: const Text('Sign in'),
                          ),
                        ),
                        const SizedBox(width: 22),
                        Expanded(
                          child: FilledButton(
                            onPressed: () async {
                              await ref.read(onboardingProvider.notifier).setOnboarded();
                              ref.read(authSwitcherProvider.notifier).update((state) => false);
                            },
                            child: const Text('Register'),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Visibility(
                          visible: currentPageNumber == 1,
                          child: TextButton(
                            onPressed: () {
                              ref.read(pageController).animateToPage(
                                    2,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeIn,
                                  );
                            },
                            child: const Text('Skip'),
                          ),
                        ),
                        FilledButton(
                          onPressed: () {
                            ref.read(pageController).animateToPage(
                                  currentPageNumber,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                );
                          },
                          child: Row(
                            children: [
                              const Text('Next').paddingOnly(right: 16),
                              const Icon(Iconsax.arrow_right_1, size: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
