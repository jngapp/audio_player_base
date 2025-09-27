import 'package:just_audio/just_audio.dart';

abstract interface class ApbIYtExplodeProvider {
  AudioSource getYtAudioSource(String videoId, dynamic tag);
}

class ApbYtExplodeProvider {
  final ApbIYtExplodeProvider _ytExplodeService;

  static ApbYtExplodeProvider? _instance;
  ApbYtExplodeProvider._internal(this._ytExplodeService);

  factory ApbYtExplodeProvider(ApbIYtExplodeProvider ytExplodeService) {
    _instance ??= ApbYtExplodeProvider._internal(ytExplodeService);
    return _instance!;
  }

  AudioSource getYtAudioSource(String videoId, dynamic tag) {
    return _instance!._ytExplodeService.getYtAudioSource(videoId, tag);
  }
}