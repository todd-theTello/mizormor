import 'package:flutter/foundation.dart' show immutable;

/// type definition of [CloseLoadingScreen]
typedef CloseLoadingScreen = bool Function();

/// type definition of [UpdateLoadingScreen]

typedef UpdateLoadingScreen = bool Function(String text);

@immutable

/// loading overlay controller
class ImageScreenController {
  /// loading overlay constructor
  const ImageScreenController({
    required this.close,
    required this.update,
  });

  /// closes the overlay
  final CloseLoadingScreen close;

  /// updates the overlay
  final UpdateLoadingScreen update;
}
