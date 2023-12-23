import 'dart:async';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Show a widget based on the full-screen state of the player and toggle the same.
class FlickFullScreenToggle extends StatelessWidget {
  const FlickFullScreenToggle({
    Key? key,
    this.enterFullScreenChild,
    this.exitFullScreenChild,
    this.size,
    this.color,
    this.padding,
    this.decoration,
  }) : super(key: key);

  /// Widget shown when player is not in full-screen.
  ///
  /// Default - [Icon(Icons.fullscreen)]
  final Widget? enterFullScreenChild;

  /// Widget shown when player is in full-screen.
  ///
  ///  Default - [Icon(Icons.fullscreen_exit)]
  final Widget? exitFullScreenChild;

  /// Size for the default icons.
  final double? size;

  /// Color for the default icons.
  final Color? color;

  /// Padding around the visible child.
  final EdgeInsetsGeometry? padding;

  /// Decoration around the visible child.
  final Decoration? decoration;

  @override
  Widget build(BuildContext context) {
    FlickControlManager controlManager =
        Provider.of<FlickControlManager>(context);
    Widget enterFullScreenWidget = enterFullScreenChild ??
        Icon(
          Icons.fullscreen,
          size: size,
          color: color,
        );
    Widget exitFullScreenWidget = exitFullScreenChild ??
        Icon(
          Icons.fullscreen_exit,
          size: size,
          color: color,
        );

    Widget child = controlManager.isFullscreen
        ? exitFullScreenWidget
        : enterFullScreenWidget;

    return GestureDetector(
      key: key,
      onTap: () {
        controlManager.toggleFullscreen();

        if (controlManager.isFullscreen) {
          FlickHelpers().lockOrientationToLandScape();
        } else {
          FlickHelpers().lockOrientationToPortrait();

          StreamSubscription<AccelerometerEvent>? subscription;
          subscription = accelerometerEventStream().listen((event) {
            if (event.y > 7) {
              FlickHelpers().unlockOrientations();
              subscription?.cancel();
            }
          });
        }
      },
      child: Container(
        padding: padding,
        decoration: decoration,
        child: child,
      ),
    );
  }
}
