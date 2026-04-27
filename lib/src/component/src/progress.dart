import 'package:audio_player_base/audio_player_base.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApbProgressWidget extends StatelessWidget {
  const ApbProgressWidget({
    super.key,
    required this.playingBuilder,
    required this.defaultBuilder,
    this.audio,
    required this.loadingBuilder,
  });

  final Widget Function(
    BuildContext context,
    double progress,
    Duration? duration,
    Duration? position,
  )
  playingBuilder;
  final Widget Function(BuildContext context) loadingBuilder;
  final Widget Function(BuildContext context, double progress) defaultBuilder;
  final ApbPlayableAudio? audio;

  @override
  Widget build(BuildContext context) {
    return ApbActiveStreamBuilder(
      loadingBuilder: (context, psStream, playlist, loadingAudio) {
        if (audio != null) {
          if (audio?.id == loadingAudio.id) {
            return loadingBuilder(context);
          } else {
            return defaultBuilder(context, audio?.progress ?? 0);
          }
        }
        return loadingBuilder(context);
      },
      startUpBuilder: (context, startUpAudio) {
        return defaultBuilder(context, startUpAudio.progress ?? 0);
      },
      defaultBuilder: (context) {
        return defaultBuilder(context, audio?.progress ?? 0);
      },
      playingBuilder: (context, psStream, playlist, playingAudio) {
        final child = ApbCustomStreamBuilder<ApbPlayerProgressState>(
          defaultBuilder: (context) {
            return defaultBuilder(context, audio?.progress ?? 0);
          },
          stream: psStream.progressStateStream,
          itemBuilder: (context, data) {
            final position = data.position;
            final duration = data.duration;
            final progress = data.progress;
            return playingBuilder(context, progress ?? 0, duration, position);
          },
        );
        if (audio != null) {
          if (audio?.id == playingAudio.id) {
            return child;
          } else {
            return defaultBuilder(context, audio?.progress ?? 0);
          }
        } else {
          return child;
        }
      },
    );
  }
}

class ApbReactiveProgressWidget extends StatefulWidget {
  const ApbReactiveProgressWidget({super.key});

  @override
  State<ApbReactiveProgressWidget> createState() =>
      _ApbReactiveProgressWidgetState();
}

class _ApbReactiveProgressWidgetState extends State<ApbReactiveProgressWidget> {
  bool isDragging = false;
  Duration? dragPosition;

  @override
  Widget build(BuildContext context) {
    return ApbProgressWidget(
      playingBuilder: (context, progress, duration, position) {
        final currentPosition =
            isDragging && dragPosition != null
                ? dragPosition!
                : (position ?? Duration.zero);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 30,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (!isDragging)
                    SizedBox(
                      height: 3,
                      child: ProgressBar(
                        progress: currentPosition,
                        total: duration ?? Duration.zero,
                        onSeek: null,
                        thumbRadius: 0,
                        barHeight: 5,
                        timeLabelLocation: TimeLabelLocation.none,
                        timeLabelType: TimeLabelType.remainingTime,
                      ),
                    ),
                  ProgressBar(
                    progress: currentPosition,
                    total: duration ?? Duration.zero,
                    onSeek: (value) {
                      context.read<ApbPlayerBloc>().add(ApbSeekEvent(value));
                      setState(() {
                        dragPosition = null;
                      });
                    },
                    thumbRadius: isDragging ? 10 : 7,
                    thumbColor: isDragging ? null : Colors.transparent,
                    thumbGlowRadius: isDragging ? 2 : 0,
                    barHeight: isDragging ? 8 : 30,
                    progressBarColor: isDragging ? null : Colors.transparent,
                    baseBarColor: isDragging ? null : Colors.transparent,
                    bufferedBarColor: isDragging ? null : Colors.transparent,
                    onDragStart: (details) {
                      setState(() {
                        isDragging = true;
                      });
                    },
                    onDragUpdate: (details) {
                      setState(() {
                        dragPosition = details.timeStamp;
                      });
                    },
                    onDragEnd: () {
                      setState(() {
                        isDragging = false;
                        dragPosition = null;
                      });
                    },
                    timeLabelLocation: TimeLabelLocation.none,
                    timeLabelType: TimeLabelType.remainingTime,
                  ),
                ],
              ),
            ),
            ProgressBar(
              progress: currentPosition,
              total: duration ?? Duration.zero,
              onSeek: null,
              thumbRadius: 0,
              barHeight: 0,
              timeLabelLocation: TimeLabelLocation.sides,
              timeLabelType: TimeLabelType.remainingTime,
            ),
          ],
        );
      },
      loadingBuilder: (context) {
        return LinearProgressIndicator();
      },
      defaultBuilder: (context, progress) {
        return LinearProgressIndicator(value: progress);
      },
    );
  }
}
