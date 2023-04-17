part of '../../ezplayer.dart';

class EzplayerSubtitleExternal {
  final String id;
  final String? title;
  final String? language;
  final String source;
  final dynamic raw;
  final Future<String> Function() load;

  EzplayerSubtitleExternal({
    required this.id,
    this.title,
    this.language,
    this.raw,
    required this.load,
    required this.source,
  });
}

class SubtitleExternal extends StatelessWidget {
  final EzPlayer ezplayer;
  const SubtitleExternal({Key? key, required this.ezplayer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EzplayerTextBtn(
      text: '外挂字幕',
      onPressed: () {
        ezplayer.showOverlay(
          alignment: Alignment.centerRight,
          builder: (context) => SyyTabBarView(
            width: 280,
            tabs: const ['字幕选择', '字幕设置'],
            children: [
              OverlaySelect(
                width: 280,
                list: [
                  OverlaySelectItem(
                    title: '不选择',
                    subtitle: '默认设置',
                    selected: ezplayer.externalSubtitle == null,
                    onPressed: () async {
                      ezplayer.setSubtitle();
                    },
                  ),
                  ...ezplayer.externalSubtitles
                      .map((item) => OverlaySelectItem(
                            title: '${item.title} ${item.language ?? ''}',
                            subtitle: item.source,
                            selected: ezplayer.externalSubtitle?.id == item.id,
                            onPressed: () async {
                              ezplayer.externalSubtitle = item;
                              String content = await item.load();
                              ezplayer.setSubtitle(content);
                            },
                          ))
                      .toList(),
                ],
              ),
              OverlaySelect(
                width: 280,
                list: [
                  OverlaySelectItem(
                    title: '字体大小',
                    subtitle: '${ezplayer.subtitleStyle.fontSize}',
                    onPressed: () async {
                      showDialog(
                        barrierColor: Colors.black12,
                        context: context,
                        builder: (context) => Dialog(
                          backgroundColor: Colors.black87,
                          alignment: Alignment.center,
                          child: ChangeNotifierBuilder(
                            notifier: ezplayer.controller.eventStream,
                            builder: (context) => EzplayerPlusMinus(
                              title: '字体大小设置',
                              value: ezplayer.subtitleStyle.fontSize.toString(),
                              onMinus: () {
                                if (ezplayer.subtitleStyle.fontSize == 6) {
                                  return;
                                }
                                ezplayer.subtitleStyle.fontSize -= 2;
                              },
                              onPlus: () {
                                if (ezplayer.subtitleStyle.fontSize == 100) {
                                  return;
                                }
                                ezplayer.subtitleStyle.fontSize += 2;
                              },
                              onReset: () {
                                ezplayer.subtitleStyle.fontSize = 14;
                              },
                              ezplayer: ezplayer,
                            ).div(DivStyle(
                              width: 180,
                              height: 180,
                              paddingTB: 20,
                              radiusAll: 20,
                            )),
                          ),
                        ),
                      );
                    },
                  ),
                  OverlaySelectItem(
                    title: '字体颜色',
                    subtitle: ezplayer.subtitleStyle.textColor.toString(),
                    trailing: Div(
                      style: DivStyle(
                        backgroundColor: ezplayer.subtitleStyle.textColor,
                        height: 16,
                        width: 16,
                        radiusAll: 10,
                      ),
                    ),
                    onPressed: () async {
                      showDialog(
                        barrierColor: Colors.black12,
                        context: context,
                        builder: (context) => Dialog(
                          backgroundColor: Colors.black87,
                          alignment: Alignment.center,
                          child: ListView(
                            children: [
                              ColorPicker(
                                pickerColor: ezplayer.subtitleStyle.textColor,
                                onColorChanged: (c) {
                                  ezplayer.subtitleStyle.textColor = c;
                                },
                              ).theme(ThemeData.dark()),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      ezplayer.subtitleStyle.textColor =
                                          Colors.blue;
                                    },
                                    child: const Text('恢复默认'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('保存修改'),
                                  ),
                                ],
                              )
                            ],
                          ).div(DivStyle(
                            height: 510,
                            width: 150,
                            alignment: Alignment.center,
                          )),
                        ),
                      );
                    },
                  ),
                  OverlaySelectItem(
                    title: '字幕位置',
                    subtitle: '${ezplayer.subtitleStyle.bottom}',
                    onPressed: () async {
                      showDialog(
                        barrierColor: Colors.black12,
                        context: context,
                        builder: (context) => Dialog(
                          backgroundColor: Colors.black87,
                          alignment: Alignment.center,
                          child: ChangeNotifierBuilder(
                            notifier: ezplayer.controller.eventStream,
                            builder: (context) => EzplayerPlusMinus(
                              title: '字幕位置设置',
                              value: ezplayer.subtitleStyle.bottom.toString(),
                              onMinus: () {
                                if (ezplayer.subtitleStyle.bottom == 0) {
                                  return;
                                }
                                ezplayer.subtitleStyle.bottom -= 5;
                              },
                              onPlus: () {
                                if (ezplayer.subtitleStyle.bottom == 200) {
                                  return;
                                }
                                ezplayer.subtitleStyle.bottom += 5;
                              },
                              onReset: () {
                                ezplayer.subtitleStyle.bottom = 20;
                              },
                              ezplayer: ezplayer,
                            ).div(DivStyle(
                              width: 180,
                              height: 180,
                              paddingTB: 20,
                              radiusAll: 20,
                            )),
                          ),
                        ),
                      );
                    },
                  ),
                  OverlaySelectItem(
                    title: '字幕同步',
                    subtitle:
                        '${ezplayer.subtitleStyle.time > 0 ? "+" : ""} ${ezplayer.subtitleStyle.time / 1000}秒',
                    onPressed: () async {
                      showDialog(
                        barrierColor: Colors.black12,
                        context: context,
                        builder: (context) => Dialog(
                          backgroundColor: Colors.black87,
                          alignment: Alignment.center,
                          child: ChangeNotifierBuilder(
                            notifier: ezplayer.controller.eventStream,
                            builder: (context) => EzplayerPlusMinus(
                              title: '字幕同步设置',
                              value: '${ezplayer.subtitleStyle.time / 1000}秒',
                              onMinus: () {
                                if (ezplayer.subtitleStyle.time == -10000) {
                                  return;
                                }
                                ezplayer.subtitleStyle.time -= 100;
                                ezplayer.subtitleController?.setTimeOffset(
                                    ezplayer.subtitleStyle.time);
                              },
                              onPlus: () {
                                if (ezplayer.subtitleStyle.time == 10000) {
                                  return;
                                }
                                ezplayer.subtitleStyle.time += 100;
                                ezplayer.subtitleController?.setTimeOffset(
                                    ezplayer.subtitleStyle.time);
                              },
                              onReset: () {
                                ezplayer.subtitleStyle.time = 0;
                                ezplayer.subtitleController?.setTimeOffset(
                                    ezplayer.subtitleStyle.time);
                              },
                              ezplayer: ezplayer,
                            ).div(DivStyle(
                              width: 180,
                              height: 180,
                              paddingTB: 20,
                              radiusAll: 20,
                            )),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
