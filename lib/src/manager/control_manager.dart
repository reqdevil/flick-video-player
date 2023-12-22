part of flick_manager;

/// Manages action on video player like play, subtitle, seek and others.
///
/// FlickControlManager helps user interact with the player,
/// like change play state, change volume, seek video, enter/exit full-screen.
class FlickControlManager extends ChangeNotifier {
  FlickControlManager({
    required FlickManager flickManager,
  }) : _flickManager = flickManager;

  final FlickManager _flickManager;
  bool _mounted = true;

  bool _isSub = false;
  bool _isFullscreen = false;
  bool _isAutoPause = false;

  /// Is player in full-screen.
  bool get isFullscreen => _isFullscreen;

  /// Is subtitle visible.
  bool get isSub => _isSub;

  VideoPlayerController? get _videoPlayerController =>
      _flickManager.flickVideoManager!.videoPlayerController;
  bool get _isPlaying => _flickManager.flickVideoManager!.isPlaying;

  /// Enter full-screen.
  void enterFullscreen() {
    print('control enter');
    _isFullscreen = true;
    _flickManager._handleToggleFullscreen();
    _notify();
  }

  /// Exit full-screen.
  void exitFullscreen() {
    print('control exit');
    _isFullscreen = false;
    _flickManager._handleToggleFullscreen();
    _notify();
  }

  /// Toggle full-screen.
  void toggleFullscreen() {
    print('toggle');
    if (_isFullscreen) {
      print('toggle exit');
      exitFullscreen();
    } else {
      print('toggle enter');
      enterFullscreen();
    }
  }

  /// Toggle play.
  void togglePlay() {
    _isPlaying ? pause() : play();
  }

  /// Replay the current playing video from beginning.
  void replay() {
    seekTo(Duration(minutes: 0));
    play();
  }

  /// Play the video.
  Future<void> play() async {
    _isAutoPause = false;

    await _videoPlayerController!.play();
    _flickManager.flickDisplayManager!.handleShowPlayerControls();
    _notify();
  }

  /// Auto-resume video.
  ///
  /// Use to resume video after a programmatic pause ([autoPause()]).
  Future<void> autoResume() async {
    if (_isAutoPause == true) {
      _isAutoPause = false;
      await _videoPlayerController?.play();
    }
  }

  /// Pause the video.
  Future<void> pause() async {
    await _videoPlayerController?.pause();
    _flickManager.flickDisplayManager!
        .handleShowPlayerControls(showWithTimeout: false);
    _notify();
  }

  /// Use this to programmatically pause the video.
  ///
  /// Example - on visibility change.
  Future<void> autoPause() async {
    _isAutoPause = true;
    await _videoPlayerController!.pause();
  }

  /// Seek video to a duration.
  Future<void> seekTo(Duration moment) async {
    await _videoPlayerController!.seekTo(moment);
  }

  /// Seek video forward by the duration.
  Future<void> seekForward(Duration videoSeekDuration) async {
    _flickManager._handleVideoSeek(forward: true);
    await seekTo(_videoPlayerController!.value.position + videoSeekDuration);
  }

  /// Seek video backward by the duration.
  Future<void> seekBackward(Duration videoSeekDuration) async {
    _flickManager._handleVideoSeek(forward: false);
    await seekTo(
      _videoPlayerController!.value.position - videoSeekDuration,
    );
  }

  /// hide the subtitle.
  Future<void> hideSubtitle() async {
    _isSub = false;
    _notify();
  }

  /// show the subtitle.
  Future<void> showSubtitle() async {
    _isSub = true;
    _notify();
  }

  /// Toggle subtitle.
  Future<void> toggleSubtitle() async {
    _isSub ? hideSubtitle() : showSubtitle();
  }

  /// Sets the playback speed of [this].
  ///
  /// [speed] indicates a speed value with different platforms accepting
  /// different ranges for speed values. The [speed] must be greater than 0.
  ///
  /// The values will be handled as follows:
  /// * On Android, some very extreme speeds will not be played back accurately.
  ///   Instead, your video will still be played back, but the speed will be
  ///   clamped by ExoPlayer (but the values are allowed by the player, like on
  ///   web).
  /// * On iOS, you can sometimes not go above `2.0` playback speed on a video.
  ///   An error will be thrown for if the option is unsupported. It is also
  ///   possible that your specific video cannot be slowed down, in which case
  ///   the plugin also reports errors.
  Future<void> setPlaybackSpeed(double speed) async {
    await _videoPlayerController!.setPlaybackSpeed(speed);
    notifyListeners();
  }

  _notify() {
    if (_mounted) {
      notifyListeners();
    }
  }

  dispose() {
    _mounted = false;
    super.dispose();
  }
}
