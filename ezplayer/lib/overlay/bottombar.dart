part of '../ezplayer.dart';

Map levelMap = {
  -1: {'title': '原画', 'subtitle': '直接返回原始文件流'},
  0: {'title': '流畅', 'subtitle': '实时转码360P'},
  1: {'title': '标清', 'subtitle': '实时转码480P'},
  2: {'title': '高清', 'subtitle': '实时转码720P'},
  3: {'title': '高清+', 'subtitle': '实时转码960P'},
  4: {'title': '超清', 'subtitle': '实时转码1080P'},
};

class _BottomBar extends StatelessWidget {
  final bool isPlaying;
  final bool isFullscreen;
  final String positionTime;
  final String totalTime;
  final SyyVideoProgressBarController pCtrl;
  final SyyVideoPlayerController syyVCtrl;
  final void Function() togglePlay;
  final List<Widget> topBtns;
  final Widget rightBtns;
  final List<Widget> bottomLeftBtns;
  final List<Widget> bottomRightBtns;
  final double playbackSpeed;
  const _BottomBar({
    Key? key,
    required this.isPlaying,
    required this.isFullscreen,
    required this.positionTime,
    required this.totalTime,
    required this.pCtrl,
    required this.syyVCtrl,
    required this.togglePlay,
    required this.playbackSpeed,
    required this.rightBtns,
    List<Widget>? topBtns,
    List<Widget>? bottomLeftBtns,
    List<Widget>? bottomRightBtns,
  })  : topBtns = topBtns ?? const [],
        bottomLeftBtns = bottomLeftBtns ?? const [],
        bottomRightBtns = bottomRightBtns ?? const [],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget playbackSpeedSelectOverlay = _PlaybackSpeedOverlay(
      syyVCtrl: syyVCtrl,
      playbackSpeed: playbackSpeed,
    );

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   syyVCtrl.updateOverlay(
    //     widget: playbackSpeedSelectOverlay,
    //     alignment: Alignment.centerRight,
    //   );
    // });

    // debug(['bottombar build', playbackSpeed]);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _PlayedTime(positionTime),
            SyyVideoProgressBar(controller: pCtrl)
                .div(SyyBoxStyle(alignment: Alignment.center, height: 10))
                .expanded(),
            _TotalTime(totalTime),
          ],
        ).div(SyyBoxStyle(
          paddingLR: 10,
        )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SyyVideoIconBtn(
                  iconData: isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                  onPressed: togglePlay,
                ),
                SyyVideoTextBtn(
                  text: playbackSpeed == 1 ? '倍速' : '${playbackSpeed}x',
                  onPressed: () {
                    syyVCtrl.showOverlay(
                      widget: playbackSpeedSelectOverlay,
                      alignment: Alignment.centerRight,
                    );
                  },
                ),
                if (isFullscreen)
                  SyyVideoTextBtn(
                      text: '画面',
                      onPressed: () {
                        syyVCtrl.showOverlay(
                          alignment: Alignment.centerRight,
                          widget: OverlaySelect(
                            title: '画面裁剪模式',
                            // width: 220,
                            list: [
                              OverlaySelectItem(
                                title: '原始比例',
                                subtitle: '默认设置',
                                selected: syyVCtrl.cutStyle == BoxFit.contain,
                                onPressed: () {
                                  syyVCtrl.setCutStyle(BoxFit.contain);
                                  syyVCtrl.hideOverlay();
                                },
                              ),
                              OverlaySelectItem(
                                title: '按比例铺满',
                                subtitle: '可能会裁剪掉一部分画面',
                                selected: syyVCtrl.cutStyle == BoxFit.cover,
                                onPressed: () {
                                  syyVCtrl.setCutStyle(BoxFit.cover);
                                  syyVCtrl.hideOverlay();
                                },
                              ),
                              OverlaySelectItem(
                                title: '拉伸铺满',
                                subtitle: '可能会使画面变形明显',
                                selected: syyVCtrl.cutStyle == BoxFit.fill,
                                onPressed: () {
                                  syyVCtrl.setCutStyle(BoxFit.fill);
                                  syyVCtrl.hideOverlay();
                                },
                              ),
                              OverlaySelectItem(
                                title: '高度铺满',
                                subtitle: '按比例缩放宽度，宽度可能会裁剪掉一部分',
                                selected: syyVCtrl.cutStyle == BoxFit.fitHeight,
                                onPressed: () {
                                  syyVCtrl.setCutStyle(BoxFit.fitHeight);
                                  syyVCtrl.hideOverlay();
                                },
                              ),
                              OverlaySelectItem(
                                title: '宽度铺满',
                                subtitle: '按比例缩放高度，高度可能会裁剪掉一部分',
                                selected: syyVCtrl.cutStyle == BoxFit.fitWidth,
                                onPressed: () {
                                  syyVCtrl.setCutStyle(BoxFit.fitWidth);
                                  syyVCtrl.hideOverlay();
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                ...bottomLeftBtns
              ],
            ),
            Row(
              children: [
                ...bottomRightBtns,
                SyyVideoTextBtn(
                    text: '音轨',
                    onPressed: () {
                      if (syyVCtrl.movieTrackerInfo == null) {
                        syyToast('视频元数据获取失败');
                        return;
                      }
                      if (syyVCtrl.movieTrackerInfo!.audioStreams.isEmpty) {
                        syyToast('视频没有音轨信息');
                        return;
                      }
                      syyVCtrl.showOverlay(
                        alignment: Alignment.centerRight,
                        widget: OverlaySelect(
                          title: '选择音轨',
                          list: syyVCtrl.movieTrackerInfo!.audioStreams
                              .map((item) {
                            String? name = item.title;
                            if (item.title == null || item.title == '') {
                              name = '音轨${item.index}';
                            }
                            return OverlaySelectItem(
                              title: name!,
                              subtitle: '${item.language}  ${item.handlerName}',
                              selected: syyVCtrl.audioTracker == item.index,
                              onPressed: () async {
                                bool needTip = false;
                                if (syyVCtrl.audioTracker == null) {
                                  needTip = true;
                                }
                                if (needTip) {
                                  bool res = await syyConfirm(
                                      '选择音轨将自动切换为实时转码模式', context);
                                  if (!res) return;
                                }
                                syyVCtrl.setAudioTracker(item.index);
                                syyVCtrl.hideOverlay();
                                syyToastSimple('音轨切换需要实时转码，已为您自动切换');
                              },
                            );
                          }).toList(),
                        ),
                      );
                    }),
                SyyVideoTextBtn(
                    text: '字幕',
                    onPressed: () {
                      if (syyVCtrl.movieTrackerInfo == null) {
                        syyToast('视频元数据获取失败');
                        return;
                      }
                      if (syyVCtrl.movieTrackerInfo!.audioStreams.isEmpty) {
                        syyToast('视频没有音轨信息');
                        return;
                      }
                      Widget subtitleWidgetSelect = OverlaySelect(
                        width: 280,
                        list: [
                          ...syyVCtrl.movieTrackerInfo!.subtitlesStream
                              .map((item) => OverlaySelectItem(
                                    title:
                                        '${item.title} ${item.language}  ${item.handlerName}',
                                    subtitle: '内挂转外挂',
                                    selected:
                                        syyVCtrl.audioTracker == item.index,
                                    onPressed: () {
                                      syyVCtrl.setAudioTracker(item.index);
                                      syyVCtrl.hideOverlay();
                                    },
                                  ))
                              .toList(),
                          if (syyVCtrl.movieSubtitleInfo != null)
                            ...syyVCtrl.movieSubtitleInfo!.innerSubtitles
                                .map((item) => OverlaySelectItem(
                                      title: basename(item.fullPath),
                                      subtitle: '本地内挂字幕',
                                      selected: syyVCtrl.subtitleFullPath ==
                                          item.fullPath,
                                      onPressed: () {
                                        syyVCtrl
                                            .setSubtitleFullPath(item.fullPath);
                                        syyVCtrl.hideOverlay();
                                        syyToastSimple('内挂需要实时转码，已为您自动切换');
                                      },
                                    ))
                                .toList(),
                          if (syyVCtrl.movieSubtitleInfo != null)
                            ...syyVCtrl.movieSubtitleInfo!.sameParent
                                .map((item) => OverlaySelectItem(
                                      title: basename(item.fullPath),
                                      subtitle: '本地外挂字幕 - 电影文件同级目录的字幕',
                                      selected: syyVCtrl.subtitleFullPath ==
                                          item.fullPath,
                                      onPressed: () {
                                        syyVCtrl
                                            .setSubtitleFullPath(item.fullPath);
                                        syyVCtrl.hideOverlay();
                                      },
                                    ))
                                .toList(),
                          if (syyVCtrl.movieSubtitleInfo != null)
                            ...syyVCtrl.movieSubtitleInfo!.allFile
                                .map((item) => OverlaySelectItem(
                                      title: basename(item.fullPath),
                                      subtitle: '本地外挂字幕 - 四有云上的近似字幕文件',
                                      selected: syyVCtrl.subtitleFullPath ==
                                          item.fullPath,
                                      onPressed: () {
                                        syyVCtrl
                                            .setSubtitleFullPath(item.fullPath);
                                        syyVCtrl.hideOverlay();
                                      },
                                    ))
                                .toList(),
                        ],
                      );

                      Widget subtitleWidgetStyle = OverlaySelect(
                        width: 280,
                        list: [
                          OverlaySelectItem(
                            title: '字体大小',
                            subtitle: '${syyVCtrl.subtitleStyle.fontSize}',
                            onPressed: () async {
                              double? res = await syyRadioSelect<double>(
                                '字体大小',
                                [
                                  SyyRadioOption('超小', 10.0),
                                  SyyRadioOption('小', 12.0),
                                  SyyRadioOption('默认', 14.0),
                                  SyyRadioOption('中', 16.0),
                                  SyyRadioOption('大', 18.0),
                                  SyyRadioOption('超大', 20.0),
                                ],
                                syyVCtrl.subtitleStyle.fontSize,
                                context,
                              );
                              log('fontSize res', res);
                              if (res != null) {
                                syyVCtrl.subtitleStyle.fontSize = res;
                                syyVCtrl.setSubtitleStyle();
                                syyVCtrl.hideOverlay();
                              }
                            },
                          ),
                          OverlaySelectItem(
                            title: '字体颜色',
                            subtitle:
                                syyVCtrl.subtitleStyle.textColor.toString(),
                            trailing: SyyDiv(
                              style: SyyBoxStyle(
                                backgroundColor:
                                    syyVCtrl.subtitleStyle.textColor,
                                height: 16,
                                width: 16,
                                radiusAll: 10,
                              ),
                            ),
                            onPressed: () async {
                              Color pickerColor =
                                  syyVCtrl.subtitleStyle.textColor;
                              Color? res = await syyBottomSheet(
                                SyyDialog(
                                  title: '字幕字体颜色设置',
                                  children: [
                                    SingleChildScrollView(
                                      child: ColorPicker(
                                        pickerColor: pickerColor,
                                        onColorChanged: (c) {
                                          pickerColor = c;
                                        },
                                      ),
                                    ),
                                  ],
                                  onOk: () {
                                    Navigator.of(context).pop(pickerColor);
                                  },
                                ),
                                alignment: Alignment.center,
                                width: 300,
                              );

                              log('字体颜色 res', res);
                              if (res != null) {
                                syyVCtrl.subtitleStyle.textColor = res;
                                syyVCtrl.setSubtitleStyle();
                                syyVCtrl.hideOverlay();
                              }
                            },
                          ),
                          OverlaySelectItem(
                            title: '字幕位置',
                            subtitle: '${syyVCtrl.subtitleStyle.bottom}',
                            onPressed: () async {
                              double? res = await syyRadioSelect<double>(
                                '字幕位置',
                                [
                                  SyyRadioOption('近底部', 10.0),
                                  SyyRadioOption('默认', 20.0),
                                  SyyRadioOption('底偏上', 30.0),
                                ],
                                syyVCtrl.subtitleStyle.bottom,
                                context,
                              );
                              log('bottom res', res);
                              if (res != null) {
                                syyVCtrl.subtitleStyle.bottom = res;
                                syyVCtrl.setSubtitleStyle();
                                syyVCtrl.hideOverlay();
                              }
                            },
                          ),
                          OverlaySelectItem(
                            title: '字幕同步',
                            subtitle:
                                '${syyVCtrl.subtitleStyle.time > 0 ? "+" : ""} ${syyVCtrl.subtitleStyle.time / 1000}秒',
                            onPressed: () async {
                              double? res = await syySliderInput(
                                context,
                                syyVCtrl.subtitleStyle.time.toDouble(),
                                min: -2000,
                                max: 2000,
                                division: 8,
                              );

                              log('字幕同步 res', res);
                              if (res != null) {
                                syyVCtrl.subtitleStyle.time = res.toInt();
                                syyVCtrl.setSubtitleStyle();
                                syyVCtrl.subtitleController
                                    ?.setTimeOffset(res.toInt());
                                syyVCtrl.hideOverlay();
                              }
                            },
                          ),
                        ],
                      );

                      syyVCtrl.showOverlay(
                        alignment: Alignment.centerRight,
                        widget: SyyTabBarView(
                          width: 280,
                          tabs: const ['字幕选择', '字幕设置'],
                          children: [
                            subtitleWidgetSelect,
                            subtitleWidgetStyle,
                          ],
                        ),
                      );
                    }),
                SyyVideoTextBtn(
                    text: levelMap[syyVCtrl.currentLevel]['title'],
                    onPressed: () async {
                      if (syyVCtrl.movieTrackerInfo == null) {
                        syyToast('视频不支持实时转码');
                        return;
                      }
                      syyVCtrl.showOverlay(
                        widget: OverlaySelect(
                          title: '选择清晰度',
                          list: [
                            OverlaySelectItem(
                              title: levelMap[-1]['title'],
                              subtitle: levelMap[-1]['subtitle'],
                              selected: syyVCtrl.currentLevel == -1,
                              onPressed: () {
                                syyVCtrl.setDefinition(-1);
                                syyVCtrl.hideOverlay();
                              },
                            ),
                            ...syyVCtrl.movieTrackerInfo!.videoStreams
                                .map((item) => OverlaySelectItem(
                                      title: levelMap[item.level]['title'],
                                      subtitle: levelMap[item.level]
                                          ['subtitle'],
                                      selected:
                                          syyVCtrl.currentLevel == item.level,
                                      onPressed: () {
                                        syyVCtrl.setDefinition(item.level);
                                        syyVCtrl.hideOverlay();
                                      },
                                    ))
                                .toList(),
                          ],
                        ),
                        alignment: Alignment.centerRight,
                      );
                    }),
                SyyVideoIconBtn(
                  iconData:
                      isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
                  onPressed: () {
                    if (isFullscreen) return Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenVideoPlayer(
                          syyVCtrl,
                          topBtns: topBtns,
                          bottomLeftBtns: bottomLeftBtns,
                          bottomRightBtns: bottomRightBtns,
                          rightBtn: rightBtns,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _PlayedTime extends StatelessWidget {
  final String positionTime;
  const _PlayedTime(this.positionTime, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      positionTime,
      style: const TextStyle(color: Colors.white, fontSize: 10),
    ).div(SyyBoxStyle(width: 48, height: 10, alignment: Alignment.bottomLeft));
  }
}

class _TotalTime extends StatelessWidget {
  final String totalTime;
  const _TotalTime(this.totalTime, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      totalTime,
      style: const TextStyle(color: Colors.white, fontSize: 10),
    ).div(SyyBoxStyle(width: 48, height: 10, alignment: Alignment.bottomRight));
  }
}

class _PlaybackSpeedOverlay extends StatelessWidget {
  final double playbackSpeed;
  final SyyVideoPlayerController syyVCtrl;
  const _PlaybackSpeedOverlay({
    Key? key,
    required this.playbackSpeed,
    required this.syyVCtrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debug(['_PlaybackSpeedOverlay build', playbackSpeed]);
    final List<double> speedList = [0.5, 0.75, 1, 1.25, 1.5, 1.75, 2];
    return OverlaySelect(
      title: '倍速播放',
      // width: 150,
      list: speedList
          .map((e) => OverlaySelectItem(
              title: '$e x',
              subtitle: e == playbackSpeed ? '当前选择' : null,
              selected: playbackSpeed == e,
              onPressed: () {
                syyVCtrl.setPlaybackSpeed(e);
                syyVCtrl.hideOverlay();
              }))
          .toList(),
    );
  }
}
