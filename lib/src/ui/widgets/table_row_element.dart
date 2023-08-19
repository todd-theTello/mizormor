import 'package:flutter/material.dart';

import '../../../utils/extensions/padding.dart';

///
TableRow buildTableRow({
  required BuildContext context,
  required String leading,
  required String trailing,
  Widget? leadingWidget,
  Widget? trailingWidget,
  TextAlign? trailingTextAlign,
  bool hasBottomPadding = true,
}) {
  final theme = Theme.of(context);
  return TableRow(children: [
    leadingWidget ??
        Text(
          leading,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey,
          ),
        ).paddingOnly(bottom: hasBottomPadding ? 24 : 0),
    trailingWidget ??
        Text(
          trailing,
          textAlign: trailingTextAlign,
          style: theme.textTheme.bodyMedium,
        ).paddingOnly(bottom: hasBottomPadding ? 24 : 0),
  ]);
}
