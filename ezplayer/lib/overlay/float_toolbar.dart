part of '../ezplayer.dart';

class FloatToolBarController extends ChangeNotifier {
  double topHeight;
  double bottomHeight;
  bool initialHide;

  double top = 0;
  double bottom = 0;

  FloatToolBarController({
    this.topHeight = 60,
    this.bottomHeight = 60,
    this.initialHide = false, // 全部采用默认值的情况一定不需要controller来控制显示和隐藏，因此需要默认为显示
    FloatToolBarController? controller,
  })  : top = initialHide ? -topHeight : 0,
        bottom = initialHide ? -bottomHeight : 0;

  @override
  void dispose() {
    super.dispose();
  }

  hidebar() {
    top = -topHeight;
    bottom = -bottomHeight;
    initialHide = true;
    notifyListeners();
  }

  openbar() {
    top = 0;
    bottom = 0;
    initialHide = false;
    notifyListeners();
  }

  toggleBar() {
    debug(['toggleBar', initialHide]);
    if (initialHide) {
      openbar();
    } else {
      hidebar();
    }
  }
}

class FloatToolBar extends StatefulWidget {
  Widget child;
  Widget topBar;
  Widget bottomBar;
  FloatToolBarController controller;

  FloatToolBar({
    Key? key,
    required this.child,
    required this.topBar,
    required this.bottomBar,
    FloatToolBarController? controller,
  })  : controller = controller ?? FloatToolBarController(),
        super(key: key);

  @override
  State<FloatToolBar> createState() => _FloatToolBarState();
}

class _FloatToolBarState extends State<FloatToolBar> {
  double top = 0;
  double bottom = 0;
  double topHeight = 60;
  double bottomHeight = 60;

  @override
  void initState() {
    top = widget.controller.top;
    bottom = widget.controller.bottom;
    topHeight = widget.controller.topHeight;
    bottomHeight = widget.controller.bottomHeight;
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
      top = widget.controller.top;
      bottom = widget.controller.bottom;
      topHeight = widget.controller.topHeight;
      bottomHeight = widget.controller.bottomHeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    double topUnsafeHeight = MediaQuery.of(context).padding.top;
    double bottpmUnsafeHeight = MediaQuery.of(context).padding.bottom;
    double topRealHeight = topHeight + topUnsafeHeight;
    double bottomRealHeight = bottomHeight + bottpmUnsafeHeight;
    double topPosition = top == 0 ? top : top - topUnsafeHeight;
    double bottomPosition = bottom == 0 ? bottom : bottom - bottpmUnsafeHeight;
    debug([
      '____________________ ddddddddddddddddddd',
      bottomPosition,
      topPosition
    ]);
    return Stack(
      children: [
        widget.child
            .div(SyyBoxStyle(backgroundColor: Colors.green, paddingAll: 20)),
        AnimatedPositioned(
          curve: Curves.decelerate,
          duration: const Duration(milliseconds: 300),
          left: 0,
          right: 0,
          top: topPosition,
          height: topRealHeight,
          child: widget.topBar,
        ).div(SyyBoxStyle(backgroundColor: Colors.red)),
        AnimatedPositioned(
          curve: Curves.decelerate,
          duration: const Duration(milliseconds: 300),
          left: 0,
          right: 0,
          bottom: bottomPosition,
          height: bottomRealHeight,
          child: widget.bottomBar,
        ).div(SyyBoxStyle(backgroundColor: Colors.blue)),
      ],
    );
  }
}
