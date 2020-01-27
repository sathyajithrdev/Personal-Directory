import 'package:flare_flutter/flare_cache.dart';
import 'package:flutter/services.dart';

const _filesToWarmUp = [
  "assets/animations/analysis.flr"
];

/// Ensure all Flare assets used by this app are cached and ready to
/// be displayed as quickly as possible.
Future<void> warmUpFlare() async {
  for (final filename in _filesToWarmUp) {
    await cachedActor(rootBundle, filename);
    await Future<void>.delayed(const Duration(milliseconds: 16));
  }
}