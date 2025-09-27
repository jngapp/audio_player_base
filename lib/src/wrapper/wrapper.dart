import 'package:audio_player_base/audio_player_base.dart' show ApbPlayerWidget, percentageFromValueInRange, playerExpandProgress, playerMinHeightPercentage, ApbPlayerBuilderConfig;
import 'package:flutter/material.dart';

class ApbPlayerWrapper extends StatelessWidget {
  const ApbPlayerWrapper({
    required this.child,
    super.key,
    required this.playerBuilderConfig,
  });

  final Widget child;
  final ApbPlayerBuilderConfig playerBuilderConfig;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [child, ApbPlayerWidget(builderConfig: playerBuilderConfig,)],
      ),
    );
  }
}

class ApbPlayerWrapperWithBottomBar extends StatelessWidget {
  const ApbPlayerWrapperWithBottomBar({
    required this.child,
    super.key,
    required this.bottomNavigationBar,
    required this.playerBuilderConfig,
  });

  final BottomNavigationBar bottomNavigationBar;
  final Widget child;
  final ApbPlayerBuilderConfig playerBuilderConfig;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: playerExpandProgress,
        builder: (context, heightPercentage, child) {
          final height = percentageFromValueInRange(
            min: playerMinHeightPercentage,
            max: 1,
            value: heightPercentage,
          );
          return SafeArea(
            bottom: heightPercentage <= playerMinHeightPercentage + 0.005 ? true : false,
            child: SizedBox(
              height:
                  kBottomNavigationBarHeight -
                  kBottomNavigationBarHeight * height,
              child: Transform.translate(
                offset: Offset(0.0, kBottomNavigationBarHeight * height),
                child: child,
              ),
            ),
          );
        },
        child: SafeArea(child: Wrap(children: [bottomNavigationBar])),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [child, ApbPlayerWidget(builderConfig: playerBuilderConfig,)],
      ),
    );
  }
}
