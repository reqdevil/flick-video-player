import 'dart:async';
import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

class FlickHelpers {
  static final List<Map<String, SpeedEnum>> speedList = [
    {'0.25': SpeedEnum.quarter},
    {'0.50': SpeedEnum.half},
    {'0.75': SpeedEnum.threeQuarters},
    {'1.00': SpeedEnum.normal},
    {'1.25': SpeedEnum.oneQuarter},
    {'1.50': SpeedEnum.oneHalf},
    {'1.75': SpeedEnum.oneThreeQuarters},
    {'2.00': SpeedEnum.double},
  ];

  static final List<Map<String, QualityEnum>> qualityList = [
    {'360p': QualityEnum.sd},
    {'720p': QualityEnum.hd},
    {'1080p': QualityEnum.uhd}
  ];

  Future<void> lockOrientationToPortrait() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  Future<void> lockOrientationToLandScape() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> unlockOrientations() async {
    if (Platform.isIOS) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  Future<bool> getIsPortraitByAccelerometer() async {
    Completer<bool> completer = Completer();
    StreamSubscription<AccelerometerEvent>? subscription;

    subscription = accelerometerEventStream().listen(
      (AccelerometerEvent event) {
        bool isPortrait = true;

        if (event.y > 7) {
          isPortrait = true;
        } else if (event.x > 7 || event.x < -7) {
          isPortrait = false;
        }

        if (!completer.isCompleted) {
          completer.complete(isPortrait);
        }

        subscription?.cancel();
      },
      onError: (error) {
        if (!completer.isCompleted) {
          completer.completeError(error);
        }
      },
    );

    return completer.future; // This will be the y value
  }
}
