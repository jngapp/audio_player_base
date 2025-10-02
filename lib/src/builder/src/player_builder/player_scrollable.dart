part of 'player_builder.dart';

class ApbScrollablePlayer extends StatefulWidget {
  const ApbScrollablePlayer({
    super.key,
    required this.playerBuilderConfig,

  });

  final ApbPlayerBuilderConfig playerBuilderConfig;

  @override
  State<ApbScrollablePlayer> createState() => _ApbScrollablePlayerState();
}

class _ApbScrollablePlayerState extends State<ApbScrollablePlayer> {
  late DraggableScrollableController controller;

  @override
  void initState() {
    super.initState();
    controller = DraggableScrollableController();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollablePlayer(
      valueNotifier: playerExpandProgress,
      controller: controller,
      builder: (context, isMini) {
        if (isMini) {
          return GestureDetector(
            onTap: () {
              controller.animateTo(
                1.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            },
            child: ApbMiniPlayer(),
          );
        } else {
          return ApbFullPlayer(
            controller: controller,
            playerBuilderConfig: widget.playerBuilderConfig,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    if(controller.isAttached) {
      controller.dispose();
    }
    super.dispose();
  }
}