part of 'player_builder.dart';

class ApbMiniPlayer extends StatelessWidget {
  const ApbMiniPlayer({super.key});


  @override
  Widget build(BuildContext context) {
    return ApbPlayerStreamBuilder(playingBuilder: (context, audio, playlist) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            color: Theme.of(context).colorScheme.surfaceContainer,
            height: getPixelFromPercentage(context, playerMinHeightPercentage),
            child: Card(
              margin: EdgeInsets.zero,
              shape: const ContinuousRectangleBorder(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ApbProgressWidget(
                    playingBuilder:
                        (context, progress, duration, position) =>
                        LinearProgressIndicator(value: progress, minHeight: 2,),
                    defaultBuilder: (context, progress) {
                      return LinearProgressIndicator(minHeight: 2, value: progress,);
                    },
                    loadingBuilder: (context) {
                      return LinearProgressIndicator(minHeight: 2,);
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ApbImageWidget(audio: audio, size: getPixelFromPercentage(context, playerMinHeightPercentage) - 5),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              FlutterMarquee(height: 20, text: '${audio.name}',
                                pauseAfterRound: Duration(seconds: 3),
                                startAfter: Duration(seconds: 3),
                                velocity: 100,),
                              Text(
                                audio.contributorsToString ?? '',
                                style: Theme.of(context).textTheme.bodySmall!,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 3),
                        child: ApbPlayPauseWidget(
                          playWidget: IconButton(
                            onPressed: () {
                              context.read<ApbPlayerBloc>().add(
                                ApbPlayAudioEvent(audio),
                              );
                            },
                            icon: Icon(Icons.play_arrow),
                          ),
                          pauseWidget: IconButton(
                            onPressed: () {
                              context.read<ApbPlayerBloc>().add(
                                const ApbPauseEvent(),
                              );
                            },
                            icon: Icon(Icons.pause),
                          ),
                          loadingWidget: CircularProgressIndicator(
                            padding: EdgeInsets.all(10),
                          ),
                          replayWidget: IconButton(
                            onPressed: () {
                              context.read<ApbPlayerBloc>().add(
                                const ApbReplayEvent(),
                              );
                            },
                            icon: Icon(Icons.replay),
                          ),
                          resumeWidget: IconButton(
                            onPressed: () {
                              context.read<ApbPlayerBloc>().add(
                                const ApbResumeEvent(),
                              );
                            },
                            icon: Icon(Icons.play_arrow),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 3),
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            context.read<ApbPlayerBloc>().add(
                              const ApbStopPlayerEvent(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });

  }
}
