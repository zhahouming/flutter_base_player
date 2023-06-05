library extension_widget;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:styled_widget/styled_widget.dart';
export 'package:styled_widget/styled_widget.dart';
part 'widgets/ink.dart';
part 'widgets/div.dart';
part 'widgets/blurdiv.dart';

extension StyledExtensionWidget on Widget {
  Widget theme(ThemeData data) => Theme(
        key: key,
        data: data,
        child: this,
      );

  Widget div([DivStyle? style]) => Div(
        key: key,
        style: style,
        child: this,
      );

  Widget shouldClip(bool clip, BorderRadius borderRadius) {
    if (clip) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: this,
      );
    } else {
      return this;
    }
  }

  Widget ink(
    Function()? onPressed, {
    double radius = 5,
    Function()? onLongPressed,
    Function()? onDoubleTap,
  }) =>
      EzInk(
        key: key,
        onPressed: onPressed,
        onLongPressed: onLongPressed,
        onDoubleTap: onDoubleTap,
        radius: radius,
        child: this,
      );

  Widget blurdiv(DivStyle? style, {double blur = 14}) => BlurDiv(
        key: key,
        blur: blur,
        style: style,
        child: this,
      );

  Widget navblur(Brightness brightness) => BlurDiv(
        style: DivStyle(
          backgroundColor:
              brightness == Brightness.dark ? Colors.black12 : Colors.white38,
          border: const Border.fromBorderSide(BorderSide.none),
        ),
        blur: 14,
        child: this,
      );

  Widget syyLinearGradient(
    List<Color> colors, {
    Alignment begin = Alignment.topLeft,
    Alignment end = Alignment.bottomRight,
  }) =>
      ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            begin: begin,
            end: end,
            colors: colors,
            tileMode: TileMode.clamp,
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstATop,
        child: this,
      );

  Widget syyShaderMask(
    List<Color> colors, {
    TileMode tileMode = TileMode.mirror,
    BlendMode blendMode = BlendMode.srcATop,
  }) =>
      ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            colors: colors,
            tileMode: tileMode,
          ).createShader(bounds);
        },
        blendMode: blendMode,
        child: this,
      );
  Widget cursor({
    Key? key,
    required MouseCursor cursor,
    bool opaque = true,
    void Function(PointerEnterEvent)? onEnter,
    void Function(PointerExitEvent)? onExit,
    void Function(PointerHoverEvent)? onHover,
    HitTestBehavior? hitTestBehavior,
  }) =>
      MouseRegion(
        key: key,
        cursor: cursor,
        opaque: opaque,
        onEnter: onEnter,
        onExit: onExit,
        onHover: onHover,
        hitTestBehavior: hitTestBehavior,
        child: this,
      );

  Widget stackWidget({
    Key? key,
    required StackPosition position,
    required Widget widget,
    DivStyle? style,
    AlignmentGeometry alignment = AlignmentDirectional.topStart,
    TextDirection? textDirection,
    StackFit fit = StackFit.loose,
    Clip clipBehavior = Clip.hardEdge,
  }) {
    return Stack(
      key: key,
      alignment: alignment,
      textDirection: textDirection,
      fit: fit,
      clipBehavior: clipBehavior,
      children: position == StackPosition.up
          ? [Div(style: style, child: this), widget]
          : [widget, Div(style: style, child: this)],
    );
  }

  Widget listener({
    Key? key,
    void Function(PointerDownEvent)? onPointerDown,
    void Function(PointerMoveEvent)? onPointerMove,
    void Function(PointerUpEvent)? onPointerUp,
    void Function(PointerHoverEvent)? onPointerHover,
    void Function(PointerCancelEvent)? onPointerCancel,
    void Function(PointerPanZoomStartEvent)? onPointerPanZoomStart,
    void Function(PointerPanZoomUpdateEvent)? onPointerPanZoomUpdate,
    void Function(PointerPanZoomEndEvent)? onPointerPanZoomEnd,
    void Function(PointerSignalEvent)? onPointerSignal,
    HitTestBehavior behavior = HitTestBehavior.deferToChild,
  }) =>
      Listener(
        key: key,
        onPointerDown: onPointerDown,
        onPointerMove: onPointerMove,
        onPointerUp: onPointerUp,
        onPointerHover: onPointerHover,
        onPointerCancel: onPointerCancel,
        onPointerPanZoomStart: onPointerPanZoomStart,
        onPointerPanZoomUpdate: onPointerPanZoomUpdate,
        onPointerPanZoomEnd: onPointerPanZoomEnd,
        onPointerSignal: onPointerSignal,
        behavior: behavior,
        child: this,
      );
}

enum StackPosition { up, down }
