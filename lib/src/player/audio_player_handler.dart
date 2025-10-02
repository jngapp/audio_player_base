import 'package:audio_player_base/audio_player_base.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class ApbPlayerProgressState {
  final Duration? position;
  final Duration? duration;
  final double? progress;
  const ApbPlayerProgressState({this.position, this.duration, this.progress});
}

class ApbShufflingState {
  final bool enabled;
  final List<int> indices;
  const ApbShufflingState({required this.enabled, required this.indices});
}

class ApbPlayerStateStream {
  static ApbPlayerStateStream? _instance;
  final AudioPlayer audioPlayer;

  ApbPlayerStateStream._(this.audioPlayer);

  static ApbPlayerStateStream getInstance(AudioPlayer player) {
    _instance ??= ApbPlayerStateStream._(player);
    return _instance!;
  }

  void dispose() {
    _instance = null;
  }

  Stream<PlayerState> get playerStateStream => audioPlayer.playerStateStream;
  Stream<PlaybackEvent> get playbackEventStream => audioPlayer.playbackEventStream;
  Stream<Duration?> get durationStream => audioPlayer.durationStream;
  Stream<LoopMode> get loopModeStream => audioPlayer.loopModeStream;
  Stream<Duration> get positionStream => audioPlayer.positionStream;
  Stream<double> get speedStream => audioPlayer.speedStream;
  Stream<int?> get currentIndexStream => audioPlayer.currentIndexStream;
  Stream<bool> get hasNextStream => audioPlayer.hasNextStream;
  Stream<bool> get hasPreviousStream => audioPlayer.hasPreviousStream;
  Stream<bool> get shuffleModeEnabledStream => audioPlayer.shuffleModeEnabledStream;
  Stream<List<int>> get shuffleIndicesStream => audioPlayer.shuffleIndicesStream;
  Stream<bool> get playingStream => audioPlayer.playingStream;
  Stream<ProcessingState> get processingStateStream => audioPlayer.processingStateStream;
  Stream<ApbPlayerProgressState?> get progressStateStream => Rx.combineLatest2(positionStream, durationStream, (position, duration) {
    if(duration == null) {
      return ApbPlayerProgressState(duration: null, position: null, progress: null);
    }
    return ApbPlayerProgressState(duration: duration, position: position, progress: position.inSeconds/duration.inSeconds);
  });

  Stream<ApbShufflingState> get shufflingStateStream => Rx.combineLatest2(shuffleModeEnabledStream, shuffleIndicesStream, (enabled, indices) {
    return ApbShufflingState(enabled: enabled, indices: indices);
  });
}

class ApbAudioPlayerHandler {
  static final ApbAudioPlayerHandler _instance = ApbAudioPlayerHandler._internal();

  AudioPlayer? _audioPlayer;
  final List<ApbPlayableAudio> _playlist = [];
  ApbPlayerStateStream? _psStream;

  ApbAudioPlayerHandler._internal();

  factory ApbAudioPlayerHandler() {
    return _instance;
  }

  AudioPlayer? get audioPlayer => _audioPlayer;
  List<ApbPlayableAudio> get playlist => _playlist;
  List<AudioSource> get audioSources => _playlist.map((e) => e.audioSource).toList();
  ApbPlayerStateStream? get psStream => _psStream;

  Future<void> init() async {
    await dispose();
    _audioPlayer ??= AudioPlayer(useProxyForRequestHeaders: false);
    _psStream = ApbPlayerStateStream.getInstance(_audioPlayer!);
  }

  Future<void> removeAudio(ApbPlayableAudio deleteAudio, {int? index}) async {
    if(index != null && index < _playlist.length) {
      _playlist.removeAt(index);
      _audioPlayer?.removeAudioSourceAt(index);
    }
    else {
      final removeIndex = _playlist.indexWhere((audio) => audio.id == deleteAudio.id);
      _audioPlayer?.removeAudioSourceAt(removeIndex);
      _playlist.removeAt(removeIndex);
    }
  }

  Future<void> insertAudio(ApbPlayableAudio audio, {int? index}) async {
    if(index != null && index < _playlist.length) {
      _playlist.insert(index, audio);
      _audioPlayer?.insertAudioSource(index, audio.audioSource);
    }
    else {
      _playlist.add(audio);
      _audioPlayer?.addAudioSource(audio.audioSource);
    }

  }

  Future<void> dispose() async {
    await _audioPlayer?.stop();
    await _audioPlayer?.dispose();
    _psStream?.dispose();
    _audioPlayer = null;
    _playlist.clear();
  }

  Future<void> initPlaylist({required List<ApbPlayableAudio> audios}) async {
    for (final audio in audios) {
      _playlist.add(audio);
    }
  }
}

Future<bool> hasNetwork() async {
  return await checkUrlAvailability('https://google.com');
}

Future<bool> checkUrlAvailability(String url) async {
  try {
    final response = await http.head(Uri.parse(url));
    return response.statusCode == 200;
  } catch (e) {
    return false;
  }
}