import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_base_player/flutter_base_player.dart';

import '../../data/data.dart';
import '../../subtitle_controller.dart';

part 'subtitle_event.dart';
part 'subtitle_state.dart';

class SubtitleBloc extends Bloc<SubtitleEvent, SubtitleState> {
  final FlutterBasePlayer videoPlayerController;
  final SubtitleRepository subtitleRepository;
  final SubtitleController subtitleController;

  late Subtitles subtitles;

  SubtitleBloc({
    required this.videoPlayerController,
    required this.subtitleRepository,
    required this.subtitleController,
  }) : super(SubtitleInitial()) {
    subtitleController.attach(this);
    on<LoadSubtitle>((event, emit) => loadSubtitle(emit: emit));
    on<InitSubtitles>((event, emit) => initSubtitles(emit: emit));
    on<UpdateLoadedSubtitle>(
      (event, emit) => emit(LoadedSubtitle(event.subtitle)),
    );
    on<CompletedShowingSubtitles>((event, emit) => emit(CompletedSubtitle()));
  }

  Future<void> initSubtitles({
    required Emitter<SubtitleState> emit,
  }) async {
    emit(SubtitleInitializing());
    subtitles = await subtitleRepository.getSubtitles();
    emit(SubtitleInitialized());
  }

  Future<void> loadSubtitle({
    required Emitter<SubtitleState> emit,
  }) async {
    emit(LoadingSubtitle());
    videoPlayerController.eventStream.addListener(
      () {
        final videoPlayerPosition = videoPlayerController.position;
        if (videoPlayerPosition.inMilliseconds >
            (subtitles.subtitles.last.endTime.inMilliseconds +
                subtitleController.timeOffset)) {
          if (!isClosed) add(CompletedShowingSubtitles());
          return;
        }
        int cTime = videoPlayerPosition.inMilliseconds -
            subtitleController.timeOffset; // 校准后的当前播放时间，实际上应该校准字幕时间，但是这样可以更节省性能
        Subtitle? cSubtitleItem;
        for (final Subtitle subtitleItem in subtitles.subtitles) {
          int sTime = subtitleItem.startTime.inMilliseconds; // 字幕开始时间
          int eTime = subtitleItem.endTime.inMilliseconds; // 字幕结束时间
          if (cTime > sTime && cTime < eTime) {
            cSubtitleItem = subtitleItem;
            if (!isClosed) add(UpdateLoadedSubtitle(subtitle: cSubtitleItem));
            return; // 找到匹配的字幕后，提前结束循环
          }
        }
        if (!isClosed) add(UpdateLoadedSubtitle(subtitle: cSubtitleItem));
      },
    );
  }

  @override
  Future<void> close() {
    subtitleController.detach();

    return super.close();
  }
}
