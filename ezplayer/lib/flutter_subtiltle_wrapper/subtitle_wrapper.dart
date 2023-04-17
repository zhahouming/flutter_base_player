library subtitle_wrapper_package;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/subtitle/subtitle_bloc.dart';
import 'index.dart';
import 'package:flutter_base_player/flutter_base_player.dart';

class SubtitleWrapper extends StatelessWidget {
  final Widget videoChild;
  final SubtitleController subtitleController;
  final FlutterBasePlayer videoPlayerController;
  final SubtitleStyle subtitleStyle;
  final Color? backgroundColor;

  const SubtitleWrapper({
    Key? key,
    required this.videoChild,
    required this.subtitleController,
    required this.videoPlayerController,
    this.subtitleStyle = const SubtitleStyle(),
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        videoChild,
        if (subtitleController.showSubtitles)
          Positioned(
            top: subtitleStyle.position.top,
            bottom: subtitleStyle.position.bottom,
            left: subtitleStyle.position.left,
            right: subtitleStyle.position.right,
            child: BlocProvider(
              create: (context) => SubtitleBloc(
                videoPlayerController: videoPlayerController,
                subtitleRepository: SubtitleDataRepository(
                  subtitleController: subtitleController,
                ),
                subtitleController: subtitleController,
              )..add(
                  InitSubtitles(
                    subtitleController: subtitleController,
                  ),
                ),
              child: SubtitleTextView(
                subtitleStyle: subtitleStyle,
                backgroundColor: backgroundColor,
              ),
            ),
          )
        else
          Container(),
      ],
    );
  }
}

class EzplayerSubtitleStyle {
  Color? backgroundColor;
  bool hasBorder;
  SubtitleBorderStyle? borderStyle;
  double fontSize;
  Color textColor;
  double? top;
  double bottom;
  double left;
  double right;
  int time;
  EzplayerSubtitleStyle({
    this.backgroundColor,
    this.hasBorder = true,
    this.borderStyle,
    this.fontSize = 14,
    this.textColor = Colors.blue,
    this.top,
    this.bottom = 20,
    this.left = 0.0,
    this.right = 0.0,
    this.time = 0,
  });
}
