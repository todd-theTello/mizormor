import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'base_text.dart';
import 'link_text.dart';

/// Custom text widget
class RichTextWidget extends StatelessWidget {
  /// constructor
  const RichTextWidget({
    required Iterable<BaseText> texts,
    super.key,
    TextStyle? styleForAll,
    TextStyle? linkStyle,
    TextAlign? textAlign,
  })  : _texts = texts,
        _styleForAll = styleForAll,
        _linkStyle = linkStyle,
        _textAlign = textAlign;

  /// iterable of texts in the rich text widget

  final TextStyle? _styleForAll;

  /// Default style for all texts

  final TextStyle? _linkStyle;

  /// Style applied to custom text

  final Iterable<BaseText> _texts;

  /// Text alignment

  final TextAlign? _textAlign;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RichText(
      textAlign: _textAlign ?? TextAlign.start,
      text: TextSpan(
          children: _texts.map(
        (baseText) {
          if (baseText is CustomText) {
            return TextSpan(
              text: baseText.text,
              style: _linkStyle ??
                  theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.primaryColor,
                  ),
              recognizer: TapGestureRecognizer()..onTap = baseText.onTapped,
            );
          } else {
            return TextSpan(
              text: baseText.text,
              style: _styleForAll ?? theme.textTheme.bodyLarge,
            );
          }
        },
      ).toList()),
    );
  }
}
