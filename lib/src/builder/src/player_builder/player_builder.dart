import 'dart:ui';

import 'package:aio_image_provider/aio_image_provider.dart';
import 'package:audio_player_base/audio_player_base.dart';
import 'package:audio_player_base/src/builder/src/player_builder/draggable_scrollable_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_just_marquee/flutter_just_marquee.dart';
import '../../../bloc/apb_player/apb_player_bloc.dart';

part 'player_mini.dart';

part 'player_full.dart';

part 'player_scrollable.dart';

const double playerMinHeightPercentage = 0.08;
const double maxHeight = 1.0;

final ValueNotifier<double> playerExpandProgress = ValueNotifier(
  playerMinHeightPercentage,
);

double getMaxImgSize(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.5;
}

double percentageFromValueInRange({required final double min, max, value}) {
  return (value - min) / (max - min);
}

double getPixelFromPercentage(BuildContext context, double percent) {
  return MediaQuery.sizeOf(context).height * percent;
}

class ApbPlayerBuilderConfig {
  final Widget playButton;
  final Widget resumeButton;
  final Widget pauseButton;
  final Widget replayButton;
  final Widget? nextButton;
  final Widget? prevButton;
  final ApbSkipWidget? skipForwardButton;
  final ApbSkipWidget? skipBackwardButton;
  final Widget? shuffleButton;
  final Widget? loopButton;
  final Widget? speedButton;
  final Widget? timerButton;
  final Widget Function(BuildContext context, ApbPlayableAudio audio)?
  secondaryWidgetBuilder;

  ApbPlayerBuilderConfig({
    this.playButton = const Icon(Icons.play_arrow, size: 50,),
    this.resumeButton = const Icon(Icons.play_arrow, size: 50,),
    this.pauseButton = const Icon(Icons.pause, size: 50,),
    this.replayButton = const Icon(Icons.replay, size: 50,),
    this.skipForwardButton,
    this.skipBackwardButton,
    required this.nextButton,
    required this.prevButton,
    this.shuffleButton,
    this.loopButton,
    this.speedButton,
    this.timerButton,
    this.secondaryWidgetBuilder,
  });
}


class ApbPlayerWidget extends StatelessWidget {
  const ApbPlayerWidget({super.key, required this.builderConfig});

  final ApbPlayerBuilderConfig builderConfig;

  @override
  Widget build(BuildContext context) {
    return ApbPlayerWidgetBuilder(
      startUpBuilder: (context, audio) {
        return ApbMiniPlayer(audio: audio);
      },
      loadingBuilder: (context, audio) {
        return ApbMiniPlayer(audio: audio);
      },
      playingBuilder: (context, playlist, audio) {
        return ApbScrollablePlayer(
          playlist: playlist,
          audio: audio,
          playerBuilderConfig: builderConfig,
        );
      },
    );
  }
}

class ApbPlayerWidgetBuilder extends StatelessWidget {
  const ApbPlayerWidgetBuilder({
    super.key,
    required this.startUpBuilder,
    required this.loadingBuilder,
    required this.playingBuilder,
  });

  final Widget Function(BuildContext context, ApbPlayableAudio audio)
  startUpBuilder;
  final Widget Function(BuildContext context, ApbPlayableAudio audio)
  loadingBuilder;
  final Widget Function(
    BuildContext context,
    ApbPlayablePlaylist playlist,
    ApbPlayableAudio audio,
  )
  playingBuilder;

  @override
  Widget build(BuildContext context) {
    return ApbActiveStreamBuilder(
      loadingBuilder: (context, psStream, playlist, loadingAudio) {
        return loadingBuilder(context, loadingAudio);
      },
      defaultBuilder: (BuildContext context) {
        return SizedBox.shrink();
      },
      startUpBuilder: (context, audio) => startUpBuilder(context, audio),
      playingBuilder: (context, psStream, playlist, playingAudio) {
        return playingBuilder(context, playlist, playingAudio);
      },
      errorBuilder: (context) => SizedBox.shrink(),
      stoppedBuilder: (context) => SizedBox.shrink(),
    );
  }
}

//
// class ApbFullPlayerBuilder extends StatelessWidget {
//   const ApbFullPlayerBuilder({
//     super.key,
//     this.playButtonBuilder,
//     this.pauseButtonBuilder,
//     this.skipForwardButtonBuilder,
//     this.skipBackwardButtonBuilder,
//     this.shuffleButtonBuilder,
//     this.speedButtonBuilder,
//     this.loopButtonBuilder,
//     this.timerButtonBuilder,
//     this.nextButtonBuilder,
//     this.prevButtonBuilder,
//   });
//
//   final Widget? playButtonBuilder;
//   final Widget? pauseButtonBuilder;
//   final Widget? nextButtonBuilder;
//   final Widget? prevButtonBuilder;
//   final Widget Function(Duration duration)? skipForwardButtonBuilder;
//   final Widget Function(Duration duration)? skipBackwardButtonBuilder;
//   final Widget Function(bool enabled)? shuffleButtonBuilder;
//   final Widget Function(double speed)? speedButtonBuilder;
//   final Widget Function(bool enabled)? loopButtonBuilder;
//   final Widget Function(ApbTimerConfig config, List<Duration> timerDurations)?
//   timerButtonBuilder;
//
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
