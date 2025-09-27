import 'package:audio_player_base/audio_player_base.dart';
import 'package:flutter/material.dart';


class ApbAudioWidget extends StatelessWidget {
  const ApbAudioWidget({
    super.key,
    required this.itemBuilder,
    required this.loadingWidget,
  });

  final Widget Function(BuildContext context, ApbPlayableAudio currentAudio) itemBuilder;
  final Widget loadingWidget;

  @override
  Widget build(BuildContext context) {
    return ApbActiveStreamBuilder(
      loadingBuilder: (context, psStream, playlist, loadingAudio) {
        return loadingWidget;
      },
      defaultBuilder: (context) {
        return loadingWidget;
      },
      playingBuilder: (context, psStream, playlist, playingAudio) {
        return itemBuilder(context, playingAudio);
      },
    );
  }
}

