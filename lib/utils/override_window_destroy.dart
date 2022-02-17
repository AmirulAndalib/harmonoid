/// This file is a part of Harmonoid (https://github.com/harmonoid/harmonoid).
///
/// Copyright © 2020-2022, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
/// All rights reserved.
///
/// Use of this source code is governed by the End-User License Agreement for Harmonoid that can be found in the EULA.txt file.
///

import 'package:flutter/services.dart';

import 'package:harmonoid/core/playback.dart';

/// OverrideWindowDestroy
/// ---------------------
///
/// Overrides the `delete-event` signal of Flutter's GTK window on Linux.
/// A constantly running instance of `libmpv` caused `Segmentation Fault` upon close.
///
/// Calling [OverrideWindowDestroy.initialize] ensures that [Playback.instance.player]
/// is disposed & then window is destroyed.
///
abstract class OverrideWindowDestroy {
  static void initialize() async {
    const channel = const MethodChannel('override_window_destroy');
    channel.setMethodCallHandler((call) async {
      await Playback.instance.player.dispose();
      channel.invokeMethod('destroy_window');
    });
  }
}
