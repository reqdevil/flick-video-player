import 'dart:async';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class FlickVideoPlayer extends StatefulWidget {
  const FlickVideoPlayer({
    Key? key,
    required this.flickManager,
    this.flickVideoWithControls = const FlickVideoWithControls(
      controls: const FlickPortraitControls(),
    ),
    this.systemUIOverlay = SystemUiOverlay.values,
    this.systemUIOverlayFullscreen = const [],
  }) : super(key: key);

  final FlickManager flickManager;

  /// Widget to render video and controls.
  final Widget flickVideoWithControls;

  /// SystemUIOverlay to show.
  ///
  /// SystemUIOverlay is changed in init.
  final List<SystemUiOverlay> systemUIOverlay;

  /// SystemUIOverlay to show in full-screen.
  final List<SystemUiOverlay> systemUIOverlayFullscreen;

  @override
  _FlickVideoPlayerState createState() => _FlickVideoPlayerState();
}

class _FlickVideoPlayerState extends State<FlickVideoPlayer>
    with WidgetsBindingObserver {
  late FlickManager flickManager;
  bool _isFullscreen = false;
  bool _isInitialized = false;
  OverlayEntry? _overlayEntry;
  double? _videoWidth;
  double? _videoHeight;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    FlickHelpers().unlockOrientations();

    flickManager = widget.flickManager;
    flickManager.registerContext(context);
    flickManager.flickControlManager!.addListener(listener);

    _setSystemUIOverlays();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('asdasdasd: $_isInitialized');
    });
  }

  @override
  void dispose() {
    flickManager.flickControlManager!.removeListener(listener);

    WakelockPlus.disable();

    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Future<bool> didPopRoute() async {
    if (_overlayEntry != null) {
      flickManager.flickControlManager!.exitFullscreen();
      return true;
    }
    return false;
  }

  @override
  void didChangeMetrics() {
    if (!_isInitialized) {
      setState(() {
        _isInitialized = true;
      });

      print('asdasd : $_isInitialized');

      return;
    }

    final Size newSize = MediaQuery.of(context).size;
    final bool isPortrait = newSize.width > newSize.height;

    if (isPortrait && flickManager.flickControlManager!.isFullscreen) {
      flickManager.flickControlManager!.exitFullscreen();
    } else if (!isPortrait && !flickManager.flickControlManager!.isFullscreen) {
      flickManager.flickControlManager!.enterFullscreen();
    }
  }

  // Listener on [FlickControlManager],
  // Pushes the full-screen if [FlickControlManager] is changed to full-screen.
  void listener() async {
    if (flickManager.flickControlManager!.isFullscreen && !_isFullscreen) {
      _switchToFullscreen();
    } else if (_isFullscreen &&
        !flickManager.flickControlManager!.isFullscreen) {
      _exitFullscreen();
    }
  }

  _switchToFullscreen() async {
    /// Disable previous wakelock setting.
    await WakelockPlus.disable();
    await WakelockPlus.enable();

    _isFullscreen = true;
    _setSystemUIOverlays();

    _overlayEntry = OverlayEntry(builder: (context) {
      return Scaffold(
        body: FlickManagerBuilder(
          flickManager: flickManager,
          child: widget.flickVideoWithControls,
        ),
      );
    });

    Overlay.of(context).insert(_overlayEntry!);
  }

  _exitFullscreen() async {
    /// Disable previous wakelock setting.
    await WakelockPlus.disable();
    await WakelockPlus.enable();

    _isFullscreen = false;
    _overlayEntry?.remove();
    _overlayEntry = null;

    _setSystemUIOverlays();
  }

  _setSystemUIOverlays() {
    if (_isFullscreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: widget.systemUIOverlayFullscreen);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: widget.systemUIOverlay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _videoWidth,
      height: _videoHeight,
      child: FlickManagerBuilder(
        flickManager: flickManager,
        child: widget.flickVideoWithControls,
      ),
    );
  }
}
