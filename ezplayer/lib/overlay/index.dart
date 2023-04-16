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
    // _vCtrl = widget.controller.vCtrl;
    // videoName = widget.controller.name;
    // _vCtrl.addListener(syncDurationState);
    // _vCtrl.addListener(syncPercent);
    // _vCtrl.addListener(syncVideoCtrl);
    // widget.controller.syncNewCtrl.addListener(syncNewCtrl);
    // widget.controller.destoryOldCtrl.addListener(destoryOldCtrl);

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
                ).gestures(
                  onTap: toggleBar,
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
        // SubtitleWrapper(
        //   videoPlayerController: videoPlayerController,
        //   subtitleController: subtitleController,
        //   subtitleStyle: subtitleStyle,
        //   backgroundColor: backgroundColor,
        //   videoChild: this,
        // ),
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
        // AnimatedPositioned(
        //   duration: const Duration(milliseconds: 300),
        //   left: hidebar ? -40 : 0,
        //   top: 0,
        //   bottom: 0,
        //   child: SyyVideoIconBtn(
        //     iconData: Icons.airplay,
        //     onPressed: () {},
        //   ).center(),
        // ),
        // right btn
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          right: hidebar ? -40 : 0,
          top: 0,
          bottom: 0,
          child: SyyVideoIconBtn(
            iconData: Icons.airplay,
            onPressed: () {},
          ).center(),
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
