library extension_widget;

import 'package:flutter/material.dart';
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
}
