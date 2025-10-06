import 'dart:ui';

import 'package:aio_image_provider/aio_image_provider.dart';
import 'package:audio_player_base/audio_player_base.dart';
import 'package:audio_player_base/src/builder/src/player_builder/draggable_scrollable_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_just_marquee/flutter_just_marquee.dart';

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

class ApbPlayerQueueBuilder {
  final Icon queueIcon;
  final Function(BuildContext context, ApbPlayablePlaylist loadingPlaylist, ApbPlayableAudio loadingAudio) loadingWidget;
  final Function(BuildContext context) defaultWidget;
  final Function(BuildContext context, List<
      ApbPlayableAudio> tracksInQueue, ApbPlayableAudio playingTrack) playingWidget;

  ApbPlayerQueueBuilder({
    required this.queueIcon,
    required this.loadingWidget,
    required this.defaultWidget,
    required this.playingWidget,});
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
  final ApbPlayerQueueBuilder? queueBuilder;
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
    this.queueBuilder,
    this.secondaryWidgetBuilder,
  });
}


class ApbPlayerWidget extends StatelessWidget {
  const ApbPlayerWidget({super.key, required this.builderConfig});

  final ApbPlayerBuilderConfig builderConfig;

  @override
  Widget build(BuildContext context) {
    return ApbPlayerStreamBuilder(playingBuilder: (context, audio, playlist) {
      return ApbScrollablePlayer(playerBuilderConfig: builderConfig);

    }, startupBuilder: (context, audio) {
      return ApbPlayerMiniWidget(audio);
    },);
  }
}