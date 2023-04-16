part of '../ezplayer.dart';

class SyyVideoProgressBarController extends ChangeNotifier {
  SyyVideoProgressBarController({
    required this.bufferedPercent,
    required this.positionPercent,
  });

  double bufferedPercent = 0;
  double positionPercent = 0;
  double newPosition = 0;
  double newTrackingPosition = 0;

  ChangeNotifier track = ChangeNotifier();
  ChangeNotifier tracking = ChangeNotifier();

  updateBuffered(double val) {
    bufferedPercent = val;
    notifyListeners();
  }

  updatePosition(double val) {
    positionPercent = val;
    notifyListeners();
  }

  setTrack(v) {
    newPosition = v;
    track.notifyListeners();
  }

  setTracking(v) {
    newTrackingPosition = v;
    tracking.notifyListeners();
  }
}

class SyyVideoProgressBar extends StatefulWidget {
  const SyyVideoProgressBar({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SyyVideoProgressBarController controller;

  @override
  State<SyyVideoProgressBar> createState() => _SyyVideoProgressBarState();
}

class _SyyVideoProgressBarState extends State<SyyVideoProgressBar> {
  double bufferedPercent = 0;
  double positionPercent = 0;
  double positionPercentDraging = 0;
  bool draging = false;
  double pp = 0;
  Color overlayColor = Colors.transparent;

  @override
  void initState() {
    syncState();
    widget.controller.addListener(syncState);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(syncState);
    super.dispose();
  }

  syncState() {
    setState(() {
      bufferedPercent = widget.controller.bufferedPercent;
      positionPercent = widget.controller.positionPercent;
      if (draging) {
        pp = positionPercentDraging;
      } else {
        pp = positionPercent;
      }
      if (!(0 <= pp && pp <= 1)) {
        pp = 0.01;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.centerStart,
      children: [
        // 缓冲进度
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          child: LinearProgressIndicator(
            backgroundColor: Colors.white70,
            valueColor: const AlwaysStoppedAnimation(
              Color.fromARGB(78, 3, 168, 244),
            ),
            minHeight: 1,
            value: bufferedPercent,
          ),
        ),
        // 播放进度
        SliderTheme(
          data: SliderThemeData(
            overlayColor: overlayColor,
            activeTrackColor: Colors.lightBlue,
            inactiveTrackColor: Colors.transparent,
            thumbColor: Colors.white70,
            trackHeight: 0.1,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 2,
            ),
            trackShape: SyyVideoFullWidthTrackShape(),
          ),
          child: Slider(
            value: pp,
            onChanged: (v) {
              widget.controller.setTracking(v);
              setState(() {
                positionPercentDraging = v;
              });
            },
            onChangeStart: (v) {
              setState(() {
                draging = true;
                overlayColor = Colors.blue.withOpacity(0.4);
              });
            },
            onChangeEnd: (v) {
              widget.controller.setTrack(v);
              setState(() {
                draging = false;
                overlayColor = Colors.transparent;
              });
            },
            divisions: 10000,
          ),
        ),
      ],
    );
  }
}

class SyyVideoFullWidthTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 0;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    // 让轨道宽度等于 Slider 宽度
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
