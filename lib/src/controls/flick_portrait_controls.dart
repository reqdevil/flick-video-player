import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';

/// Default portrait controls.
class FlickPortraitControls extends StatelessWidget {
  const FlickPortraitControls(
      {Key? key,
      this.iconSize = 20,
      this.fontSize = 12,
      this.progressBarSettings})
      : super(key: key);

  /// Icon size.
  ///
  /// This size is used for all the player icons.
  final double iconSize;

  /// Font size.
  ///
  /// This size is used for all the text.
  final double fontSize;

  /// [FlickProgressBarSettings] settings.
  final FlickProgressBarSettings? progressBarSettings;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: FlickAutoHideChild(
            child: ColoredBox(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
        ),
        Positioned.fill(
          child: FlickShowControlsAction(
            child: FlickSeekVideoAction(
              child: Center(
                child: FlickVideoBuffer(
                  child: FlickAutoHideChild(
                    showIfVideoNotInitialized: false,
                    child: FlickPlayToggle(
                      size: 30,
                      color: Colors.white,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: FlickAutoHideChild(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      FlickCurrentPosition(
                        fontSize: fontSize,
                      ),
                      FlickAutoHideChild(
                        child: Text(
                          ' / ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: fontSize,
                          ),
                        ),
                      ),
                      FlickTotalDuration(
                        fontSize: fontSize,
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      FlickFullScreenToggle(
                        size: iconSize,
                      ),
                    ],
                  ),
                  FlickVideoProgressBar(
                    flickProgressBarSettings: progressBarSettings,
                  ),
                  SizedBox(
                    height: iconSize,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
