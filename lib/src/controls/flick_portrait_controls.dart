import 'dart:math';
import 'package:flick_video_player/src/utils/flick_quality_enum.dart';
import 'package:flick_video_player/src/utils/flick_setting_enum.dart';
import 'package:flick_video_player/src/utils/flick_speed_enum.dart';
import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

/// Default portrait controls.
class FlickPortraitControls extends StatefulWidget {
  const FlickPortraitControls({
    Key? key,
    this.iconSize = 20,
    this.fontSize = 12,
    this.progressBarSettings,
    this.popFunction,
  }) : super(key: key);

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

  final Function()? popFunction;

  @override
  State<FlickPortraitControls> createState() => _FlickPortraitControlsState();
}

class _FlickPortraitControlsState extends State<FlickPortraitControls> {
  final List<Map<String, SpeedEnum>> speedList = [
    {'0.25': SpeedEnum.quarter},
    {'0.50': SpeedEnum.half},
    {'0.75': SpeedEnum.threeQuarters},
    {'1.00': SpeedEnum.normal},
    {'1.25': SpeedEnum.oneQuarter},
    {'1.50': SpeedEnum.oneHalf},
    {'1.75': SpeedEnum.oneThreeQuarters},
    {'2.00': SpeedEnum.double},
  ];

  final List<Map<String, QualityEnum>> qualityList = [
    {'360p': QualityEnum.sd},
    {'720p': QualityEnum.hd},
    {'1080p': QualityEnum.uhd}
  ];

  late FlickControlManager controlManager =
      Provider.of<FlickControlManager>(context, listen: false);
  late FlickVideoManager videoManager =
      Provider.of<FlickVideoManager>(context, listen: false);

  VideoSettingEnum settingEnum = VideoSettingEnum.quality;
  SpeedEnum videoSpeed = SpeedEnum.normal;
  bool isSettings = false;

  @override
  Widget build(BuildContext context) {
    return isSettings ? settingsBody() : playBody();
  }

  Widget playBody() {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: FlickAutoHideChild(
            child: Container(
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (!controlManager.isFullscreen)
                        GestureDetector(
                          onTap: widget.popFunction,
                          child: CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 205, 0, 14),
                            radius: 15,
                            child: Transform.rotate(
                              angle: pi * 1.5,
                              child: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          controlManager.pause();

                          setState(() {
                            isSettings = true;
                          });
                        },
                        child: const CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 205, 0, 14),
                          radius: 15,
                          child: Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
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
                        fontSize: widget.fontSize,
                      ),
                      FlickAutoHideChild(
                        child: Text(
                          ' / ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: widget.fontSize,
                          ),
                        ),
                      ),
                      FlickTotalDuration(
                        fontSize: widget.fontSize,
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      FlickFullScreenToggle(
                        size: widget.iconSize,
                      ),
                    ],
                  ),
                  FlickVideoProgressBar(
                    flickProgressBarSettings: widget.progressBarSettings,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget settingsBody() {
    return GestureDetector(
      onVerticalDragUpdate: (details) {},
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              controlManager.play();

              setState(() {
                isSettings = false;
              });
            },
            child: Opacity(
              opacity: 0.7,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black,
                padding: const EdgeInsets.all(15),
              ),
            ),
          ),
          Padding(
            padding: controlManager.isFullscreen
                ? const EdgeInsets.all(60)
                : const EdgeInsets.all(20),
            child: Center(
              child: Card(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            splashColor: Color.fromARGB(255, 80, 80, 80),
                            onTap: () {
                              setState(() {
                                settingEnum = VideoSettingEnum.quality;
                              });
                            },
                            title: Text(
                              'Kalite',
                              style: TextStyle(
                                fontFamily: 'Jost',
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            trailing: settingEnum == VideoSettingEnum.quality
                                ? Transform.rotate(
                                    angle: pi,
                                    child: const Icon(Icons.arrow_back_ios_new),
                                  )
                                : null,
                          ),
                          ListTile(
                            splashColor: Color.fromARGB(255, 80, 80, 80),
                            onTap: () {
                              setState(() {
                                settingEnum = VideoSettingEnum.speed;
                              });
                            },
                            title: Text(
                              'Oynatma Hızı',
                              style: TextStyle(
                                fontFamily: 'Jost',
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            trailing: settingEnum == VideoSettingEnum.speed
                                ? Transform.rotate(
                                    angle: pi,
                                    child: const Icon(Icons.arrow_back_ios_new),
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: settingEnum == VideoSettingEnum.quality
                            ? qualitySettings()
                            : speedSettings(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget qualitySettings() {
    return ListView.builder(
      itemCount: qualityList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            qualityList[index].keys.first,
            style: TextStyle(
              fontFamily: 'Jost',
              fontSize: 18.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          trailing: videoManager.quality == qualityList[index].values.first
              ? const Icon(Icons.check_rounded)
              : null,
          onTap: () {
            if (videoManager.quality != qualityList[index].values.first) {
              setState(() {
                isSettings = false;
                videoManager.quality = qualityList[index].values.first;
              });

              videoManager.changeVideoQuality();
            }
          },
        );
      },
    );
  }

  Widget speedSettings() {
    return ListView.builder(
      itemCount: speedList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            speedList[index].keys.first,
            style: TextStyle(
              fontFamily: 'Jost',
              fontSize: 18.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          trailing: speedList[index].values.first == videoSpeed
              ? const Icon(Icons.check_rounded)
              : null,
          onTap: () async {
            await controlManager.pause();

            setState(() {
              isSettings = false;
              videoSpeed = SpeedEnum.quarter;
              controlManager.play();
            });

            controlManager.setPlaybackSpeed(0.25);
          },
        );
      },
    );
  }
}
