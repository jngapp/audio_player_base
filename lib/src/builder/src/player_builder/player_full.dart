part of 'player_builder.dart';

class ApbFullPlayer extends StatelessWidget {
  const ApbFullPlayer({
    super.key,
    required this.audio,
    required this.playlist,
    required this.controller,
    required this.playerBuilderConfig,
  });

  final ApbPlayableAudio audio;
  final ApbPlayablePlaylist playlist;
  final DraggableScrollableController controller;
  final ApbPlayerBuilderConfig playerBuilderConfig;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: audio.imagePath != null
              ? AipFileImage(path: audio.imagePath!).imageProvider
              : AipUrlImage(url: audio.imageUrl ?? '').imageProvider,
          fit: BoxFit.fill,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 7.5, sigmaY: 7.5),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceBright.withValues(alpha: 0.6),
          ),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SafeArea(
                      child: SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                controller.animateTo(
                                  playerMinHeightPercentage,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                );
                              },
                              icon: const Icon(Icons.expand_more, size: 33),
                            ),
                            Expanded(
                              child: Text(
                                playlist.name!,
                                style: Theme.of(context).textTheme.titleMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    OverflowBlurWidget(
                      height: MediaQuery.sizeOf(context).height - 300 - 50 - 2 * kToolbarHeight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: ApbImageWidget(audio: audio, size: MediaQuery.sizeOf(context).width),
                      ),
                    ),
                    SizedBox(
                      height: 300,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FlutterMarquee(
                              text: audio.name!,
                              height: 30,
                              pauseAfterRound: Duration(seconds: 3),
                              startAfter: Duration(seconds: 3),
                              velocity: 100,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              audio.contributorsToString ?? '',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 20,
                              child: ApbReactiveProgressWidget(),
                            ),
                            Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    ApbPrevWidget(widget: playerBuilderConfig.prevButton,),
                                    playerBuilderConfig.skipBackwardButton ?? SizedBox.shrink(),
                                    ApbPlayPauseWidget(
                                      pauseWidget: IconButton(
                                        onPressed: () {
                                          context
                                              .read<ApbPlayerBloc>()
                                              .add(ApbPauseEvent());
                                        },
                                        icon: playerBuilderConfig.pauseButton,
                                      ),
                                      playWidget: IconButton(
                                        onPressed: () {
                                          context
                                              .read<ApbPlayerBloc>()
                                              .add(ApbResumeEvent());
                                        },
                                        icon: playerBuilderConfig.playButton,
                                      ),
                                      loadingWidget:
                                      CircularProgressIndicator(
                                        padding: EdgeInsets.all(15),
                                      ),
                                      replayWidget: IconButton(
                                        onPressed: () {
                                          context
                                              .read<ApbPlayerBloc>()
                                              .add(ApbReplayEvent());
                                        },
                                        icon: playerBuilderConfig.replayButton,
                                      ),
                                      resumeWidget: IconButton(
                                        onPressed: () {
                                          context
                                              .read<ApbPlayerBloc>()
                                              .add(ApbResumeEvent());
                                        },
                                        icon: playerBuilderConfig.resumeButton,
                                      ),
                                    ),
                                    playerBuilderConfig.skipForwardButton ?? SizedBox.shrink(),
                                    ApbNextWidget(widget: playerBuilderConfig.nextButton,),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    if(playerBuilderConfig.speedButton != null) playerBuilderConfig.speedButton!,
                                    if(playerBuilderConfig.timerButton != null) playerBuilderConfig.timerButton!,
                                    if(playerBuilderConfig.loopButton != null) playerBuilderConfig.loopButton!,
                                    if(playerBuilderConfig.shuffleButton != null) playerBuilderConfig.shuffleButton!,
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if(playerBuilderConfig.secondaryWidgetBuilder != null) playerBuilderConfig.secondaryWidgetBuilder!.call(context, audio),
            ],
          ),
        ),
      ),
    );
  }
}
