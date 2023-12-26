import 'bloc/subtitle/subtitle_bloc.dart';

class SubtitleController {
  String? subtitlesContent;
  String? subtitleUrl;
  Map<String, String>? headers;
  final bool showSubtitles;
  SubtitleDecoder? subtitleDecoder;
  SubtitleType subtitleType;
  //
  bool _attached = false;
  SubtitleBloc? _subtitleBloc;

  int timeOffset = 0;

  SubtitleController({
    this.subtitleUrl,
    this.headers,
    this.subtitlesContent,
    this.showSubtitles = true,
    this.subtitleDecoder,
    this.subtitleType = SubtitleType.webvtt,
  });

  void attach(SubtitleBloc subtitleBloc) {
    _subtitleBloc = subtitleBloc;
    _attached = true;
  }

  void detach() {
    _attached = false;
    _subtitleBloc = null;
  }

  void updateSubtitleUrl({
    required String url,
    Map<String, String>? headers,
  }) {
    if (_attached) {
      subtitleUrl = url;
      headers = headers;
      _subtitleBloc!.add(
        InitSubtitles(
          subtitleController: this,
        ),
      );
    } else {
      throw Exception('Seems that the controller is not correctly attached.');
    }
  }

  void setTimeOffset(int offset) {
    timeOffset = offset;
  }

  void updateSubtitleContent({
    required String content,
  }) {
    if (_attached) {
      subtitlesContent = content;
      _subtitleBloc!.add(
        InitSubtitles(
          subtitleController: this,
        ),
      );
    } else {
      throw Exception('Seems that the controller is not correctly attached.');
    }
  }
}

enum SubtitleDecoder {
  utf8,
  latin1,
}

enum SubtitleType {
  webvtt,
  srt,
}
