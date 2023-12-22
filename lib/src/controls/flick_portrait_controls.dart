import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

/// Default portrait controls.
class FlickPortraitControls extends StatefulWidget {
  const FlickPortraitControls({
    Key? key,
    this.popFunction,
  }) : super(key: key);

  final Function()? popFunction;

  @override
  State<FlickPortraitControls> createState() => _FlickPortraitControlsState();
}

class _FlickPortraitControlsState extends State<FlickPortraitControls> {
  late FlickControlManager controlManager =
      Provider.of<FlickControlManager>(context);
  late FlickVideoManager videoManager = Provider.of<FlickVideoManager>(context);

  final double iconSize = 20;
  final double fontSize = 12;

  VideoSettingEnum settingEnum = VideoSettingEnum.quality;
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
              color: Colors.black.withOpacity(0.4),
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
                        shape: BoxShape.circle,
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
              padding: controlManager.isFullscreen
                  ? EdgeInsets.only(
                      left: MediaQuery.viewPaddingOf(context).top,
                      right: MediaQuery.viewPaddingOf(context).top,
                    )
                  : const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (widget.popFunction != null &&
                          !controlManager.isFullscreen)
                        GestureDetector(
                          onTap: widget.popFunction,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.expand_more,
                              color: Colors.white,
                              size: 30,
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
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.settings,
                              color: Colors.white,
                              size: 20,
                            ),
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
                        fontSize: fontSize,
                      ),
                      FlickAutoHideChild(
                        child: Text(
                          ' / ',
                          style: TextStyle(
                            fontFamily: 'Jost',
                            fontSize: fontSize,
                            color: Colors.white,
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
                    flickProgressBarSettings: FlickProgressBarSettings(
                      playedColor: Color.fromARGB(255, 205, 0, 14),
                      handleColor: Color.fromARGB(255, 205, 0, 14),
                      handleRadius: 5,
                    ),
                  ),
                  if (controlManager.isFullscreen)
                    SizedBox(height: MediaQuery.viewPaddingOf(context).top)
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
                      child: settingEnum == VideoSettingEnum.quality
                          ? qualitySettings()
                          : speedSettings(),
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
      padding: EdgeInsets.zero,
      itemCount: FlickHelpers.qualityList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            FlickHelpers.qualityList[index].keys.first,
            style: TextStyle(
              fontFamily: 'Jost',
              fontSize: 18.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          trailing: videoManager.quality ==
                  FlickHelpers.qualityList[index].values.first
              ? const Icon(Icons.check_rounded)
              : null,
          onTap: () {
            if (videoManager.quality !=
                FlickHelpers.qualityList[index].values.first) {
              setState(() {
                isSettings = false;
                videoManager.quality =
                    FlickHelpers.qualityList[index].values.first;
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
      padding: EdgeInsets.zero,
      itemCount: FlickHelpers.speedList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            FlickHelpers.speedList[index].keys.first,
            style: TextStyle(
              fontFamily: 'Jost',
              fontSize: 18.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          trailing: FlickHelpers.speedList[index].values.first ==
                  videoManager.videoSpeed
              ? const Icon(Icons.check_rounded)
              : null,
          onTap: () async {
            await controlManager.pause();

            setState(() {
              isSettings = false;
              videoManager.videoSpeed =
                  FlickHelpers.speedList[index].values.first;
              controlManager.play();
            });

            controlManager.setPlaybackSpeed(
              double.parse(FlickHelpers.speedList[index].keys.first),
            );
          },
        );
      },
    );
  }
}
