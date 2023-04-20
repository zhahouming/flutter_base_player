part of '../ezplayer.dart';

class PlayerOverlay extends StatefulWidget {
  final EzPlayer ezplayer;
  final FlutterBasePlayer controller;
  final bool isFullscreen;
  const PlayerOverlay({
    Key? key,
    required this.ezplayer,
    required this.controller,
    this.isFullscreen = false,
  }) : super(key: key);

  @override
  State<PlayerOverlay> createState() => _PlayerOverlayState();
}

class _PlayerOverlayState extends State<PlayerOverlay>
    with
        _BaseMixin,
        _OverlayTimerMixin,
        _LongPressMixin,
        _ProgressMixin,
        _DragBottomMixin,
        _DragLeftRightAreaMixin,
        _MethodsMixin {
  @override
  void initState() {
    initTimer();
    initProgress();
    initDragTB();
    initDragBottom();
    Wakelock.enable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        LayoutBuilder(
            builder: (context, box) => Div(
                  style: DivStyle(
                    height: box.maxHeight,
                    width: box.maxWidth,
                    backgroundColor: Colors.black12,
                  ),
                )
                    .subtitle(
                      videoPlayerController: widget.controller,
                      subtitleController: widget.ezplayer.subtitleController,
                      backgroundColor:
                          widget.ezplayer.subtitleStyle.backgroundColor,
                      subtitleStyle: SubtitleStyle(
                        hasBorder: widget.ezplayer.subtitleStyle.hasBorder,
                        borderStyle:
                            widget.ezplayer.subtitleStyle.borderStyle ??
                                const SubtitleBorderStyle(),
                        fontSize: widget.isFullscreen
                            ? widget.ezplayer.subtitleStyle.fontSize * 1.8
                            : widget.ezplayer.subtitleStyle.fontSize,
                        textColor: widget.ezplayer.subtitleStyle.textColor,
                        position: SubtitlePosition(
                          top: widget.ezplayer.subtitleStyle.top,
                          bottom: widget.ezplayer.subtitleStyle.bottom,
                          left: widget.ezplayer.subtitleStyle.left,
                          right: widget.ezplayer.subtitleStyle.right,
                        ),
                      ),
                    )
                    .gestures(
                      onTap: toggleBar,
                      onDoubleTap: onDoubleTap,
                      onLongPressStart: onLongPressStart,
                      onLongPressMoveUpdate: (d) =>
                          onLongPressMoveUpdate(d, context),
                      onLongPressEnd: onLongPressEnd,
                      onHorizontalDragStart: onHorizontalDragStart,
                      onHorizontalDragUpdate: onHorizontalDragUpdate,
                      onHorizontalDragEnd: onHorizontalDragEnd,
                      onHorizontalDragCancel: onHorizontalDragCancel,
                      onVerticalDragStart: onVerticalDragStart,
                      onVerticalDragUpdate: onVerticalDragUpdate,
                      onVerticalDragEnd: onVerticalDragEnd,
                      onVerticalDragCancel: onVerticalDragCancel,
                    )),
        if (!widget.controller.isPlaying &&
            !widget.controller.hasError &&
            !widget.controller.completed)
          Container(
            color: Colors.black54,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 56,
                  icon: const Icon(
                    Icons.play_circle,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                    togglePlay();
                  },
                ),
              ],
            ),
          ),
        if (widget.controller.completed && !widget.controller.hasError)
          Container(
            // height: box.maxWidth / (ratio ?? aspectRatio),
            // width: box.maxWidth,
            color: Colors.black54,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.replay,
                    color: Color.fromARGB(255, 67, 173, 255),
                  ),
                  onPressed: () {
                    widget.controller.replay();
                  },
                ),
                TextButton(
                  onPressed: () {
                    widget.controller.replay();
                  },
                  child: const Text(
                    '重新播放',
                    style: TextStyle(color: Color.fromARGB(255, 67, 173, 255)),
                  ),
                ),
              ],
            ),
          ),
        // topBar
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          left: 0,
          top: hidebar ? -40 : 0,
          right: 0,
          height: 40,
          child: TopBar(
            isFullscreen: widget.isFullscreen,
            titleText: widget.ezplayer.videoName ?? widget.controller.filename,
            player: widget.controller,
            ezplayer: widget.ezplayer,
            menuBtns: widget.ezplayer.menuBtns,
          ).div(DivStyle(
            gradient: const LinearGradient(
              colors: [Colors.black87, Colors.black26, Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          )),
        ),

        // bottomBar
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          left: 0,
          bottom: hidebar ? -50 : 0,
          right: 0,
          child: BottomBar(
            isFullscreen: widget.isFullscreen,
            pCtrl: pCtrl,
            positionTime: positionTime,
            totalTime: totalTime,
            togglePlay: togglePlay,
            bottomLeftBtns: widget.ezplayer.bottomLeftBtns,
            bottomRightBtns: widget.ezplayer.bottomRightBtns,
            playbackSpeed: widget.controller.playbackSpeed,
            player: widget.controller,
            ezplayer: widget.ezplayer,
            isPlaying: isPlaying,
          ).div(DivStyle(
            gradient: const LinearGradient(
              colors: [Colors.black87, Colors.black26, Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          )),
        ),

        // left btn
        if (widget.ezplayer.leftBtn != null)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: hidebar ? -40 : 0,
            top: 0,
            bottom: 0,
            child: widget.ezplayer.leftBtn!.center(),
          ),

        // right btn
        if (widget.ezplayer.rightBtn != null)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            right: hidebar ? -40 : 0,
            top: 0,
            bottom: 0,
            child: widget.ezplayer.rightBtn!.center(),
          ),

        if (seeking)
          SeekingOverlay(
            newPositionTime: newPositionTime,
            totalTime: totalTime,
          ).positioned(left: 0, bottom: 0, right: 0, top: 0),
        if (iSpeedUpMode)
          SpeedUpOverlay(
            speed: speed,
          ).positioned(left: 0, bottom: 0, right: 0, top: 0),
        if (settingLight)
          VSlider(
            percent: lightPercent,
            iconData: Icons.sunny,
          ).positioned(left: 17, top: 50, bottom: 50),
        if (settingVolume)
          VSlider(
            percent: volumePercent,
            iconData: Icons.volume_up,
          ).positioned(right: 17, top: 50, bottom: 50),
      ],
    );
  }
}
