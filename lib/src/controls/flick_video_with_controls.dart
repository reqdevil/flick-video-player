import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

/// Default Video with Controls.
///
/// Returns a Stack with the following arrangement.
///    * [FlickVideoPlayer]
///    * Stack (Wrapped with [Positioned.fill()])
///      * Video Player loading fallback (conditionally rendered if player is not initialized).
///      * Video player error fallback (conditionally rendered if error in initializing the player).
///      * Controls.
class FlickVideoWithControls extends StatefulWidget {
  const FlickVideoWithControls({
    Key? key,
    this.controls = const FlickPortraitControls(),
  }) : super(key: key);

  /// Create custom controls or use any of these [FlickPortraitControls], [FlickLandscapeControls]
  final Widget controls;

  @override
  _FlickVideoWithControlsState createState() => _FlickVideoWithControlsState();
}

class _FlickVideoWithControlsState extends State<FlickVideoWithControls> {
  VideoPlayerController? _videoPlayerController;

  bool isContain = true;

  @override
  void didChangeDependencies() {
    VideoPlayerController? newController =
        Provider.of<FlickVideoManager>(context).videoPlayerController;
    if (_videoPlayerController != newController ||
        _videoPlayerController == null) {
      _videoPlayerController = newController;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    FlickControlManager controlManager =
        Provider.of<FlickControlManager>(context);
    bool _showVideoCaption = controlManager.isSub;

    return IconTheme(
      data: const IconThemeData(
        color: Colors.white,
        size: 20,
      ),
      child: LayoutBuilder(builder: (context, size) {
        return Container(
          color: Colors.black,
          child: DefaultTextStyle(
            style: const TextStyle(
              fontFamily: 'Jost',
              fontSize: 12,
              color: Colors.white,
            ),
            child: Stack(
              children: <Widget>[
                Center(
                  child: FlickNativeVideoPlayer(
                    videoPlayerController: _videoPlayerController,
                    fit: BoxFit.contain,
                    aspectRatioWhenLoading: 16 / 9,
                  ),
                ),
                Positioned.fill(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      _videoPlayerController!.closedCaptionFile != null &&
                              _showVideoCaption
                          ? Positioned(
                              bottom: 5,
                              child: Transform.scale(
                                scale: 0.7,
                                child: ClosedCaption(
                                  textStyle: const TextStyle(
                                    fontFamily: 'Jost',
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                  text: _videoPlayerController!
                                      .value.caption.text,
                                ),
                              ),
                            )
                          : SizedBox(),
                      if (_videoPlayerController?.value.hasError == false &&
                          _videoPlayerController?.value.isInitialized == false)
                        const Center(
                          child: CircularProgressIndicator(
                            color: Color.fromARGB(255, 205, 0, 14),
                          ),
                        ),
                      if (_videoPlayerController?.value.hasError == true)
                        Center(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              Icons.error,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      widget.controls
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
