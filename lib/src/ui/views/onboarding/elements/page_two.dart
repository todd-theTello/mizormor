import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mizormor/utils/extensions/padding.dart';

/// Second page on the onboarding view
class PageTwo extends StatelessWidget {
  /// Page two constructor
  const PageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SvgPicture.asset('assets/images/onboarding/onboarding-2.svg'),
          ),
          Text('Welcome to Mizormor', style: textTheme.titleMedium).paddingOnly(bottom: 14),
          Text(
            'Plan your trip, we will take care of how you get there',
            style: textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
