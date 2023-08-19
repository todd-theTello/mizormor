import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mizormor/utils/extensions/padding.dart';

/// First page on the onboarding view
class PageOne extends StatelessWidget {
  /// Page one constructor
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SvgPicture.asset('assets/images/onboarding/onboarding-1.svg'),
          ),
          Text('Welcome to Mizormor',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              )).paddingOnly(bottom: 14),
          Text(
            'Book scheduled bus trips from the anywhere and board at preferred stops',
            style: textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
