import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mizormor/utils/extensions/padding.dart';

/// Third page on the onboarding view
class PageThree extends StatelessWidget {
  /// Page three constructor
  const PageThree({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SvgPicture.asset('assets/images/onboarding/onboarding-3.svg'),
          ),
          Text('Welcome to Mizormor', style: textTheme.titleMedium).paddingOnly(bottom: 14),
          Text(
            'Keep track and get notified about your trip and status',
            style: textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
