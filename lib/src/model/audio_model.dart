import 'package:aio_image_provider/aio_image_provider.dart';
import 'package:audio_player_base/audio_player_base.dart';
import 'package:get_it/get_it.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

part 'audio_model.g.dart';

enum ApbPlayableFileType {
  @JsonValue('file')
  file,
  @JsonValue('url')
  url,
  @JsonValue('yt')
  yt,
  @JsonValue('unknown')
  unknown,
  @JsonValue('asset')
  asset,
}

abstract class ApbPlayableAudio {
  final String? id;
  final String? sourceId;
  final String? playlistId;
  final String? name;
  final String? imageUrl;
  final String? imagePath;
  final String? fileUrl;
  final String? filePath;
  final Duration? position;
  final Duration? duration;
  final DateTime? createdAt;
  final ApbPlayableFileType? fileType;
  final List<String>? contributors;
  final String? lyrics;

  ApbPlayableAudio({
    this.id,
    this.sourceId,
    this.name,
    this.contributors,
    this.imageUrl,
    this.imagePath,
    this.fileUrl,
    this.filePath,
    this.position,
    this.duration,
    this.fileType,
    this.playlistId,
    this.createdAt,
    this.lyrics,
  });

  AudioSource get audioSource;

  MediaItem get tag => MediaItem(
    id: sourceId ?? id!,
    title: name!,
    artist: contributorsToString,
    artUri: imagePath != null ? Uri.file('${AioImageProvider().saveDirectory}/${imagePath!}') : imageUrl != null ? Uri.parse(imageUrl!) : null,
  );

  String? get contributorsToString => contributors?.join(', ');

  double? get progress {
    if (duration == null) return null;
    return position != null ? position!.inSeconds / duration!.inSeconds : 0;
  }

  factory ApbPlayableAudio.fromJson(Map<String, dynamic> json) {
    switch (json['fileType']) {
      case 'url':
        return ApbUrlPlayableAudio.fromJson(json);
      case 'asset':
        return ApbAssetPlayableAudio.fromJson(json);
      case 'file':
        return ApbFilePlayableAudio.fromJson(json);
      default:
        throw UnimplementedError();
    }
  }

  Map<String, dynamic> toJson();

  ApbPlayableAudio copyWith({
    String? id,
    String? sourceId,
    String? playlistId,
    String? name,
    String? imageUrl,
    String? imagePath,
    String? fileUrl,
    String? filePath,
    Duration? position,
    Duration? duration,
    DateTime? createdAt,
    List<String>? contributors,
    String? lyrics,
  });
}

@JsonSerializable(includeIfNull: true)
class ApbUrlPlayableAudio extends ApbPlayableAudio {
  ApbUrlPlayableAudio({
    required super.id,
    super.sourceId,
    required super.name,
    required super.fileUrl,
    super.imageUrl,
    super.imagePath,
    super.position,
    super.duration,
    super.contributors,
    super.playlistId,
    super.createdAt,
    super.lyrics,
  }) : super(filePath: null, fileType: ApbPlayableFileType.url);

  @override
  AudioSource get audioSource {
    return ProgressiveAudioSource(Uri.parse(fileUrl!), tag: tag);
  }

  @override
  factory ApbUrlPlayableAudio.fromJson(Map<String, dynamic> json) =>
      _$ApbUrlPlayableAudioFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ApbUrlPlayableAudioToJson(this);

  @override
  ApbPlayableAudio copyWith({
    String? id,
    String? sourceId,
    String? playlistId,
    String? name,
    String? imageUrl,
    String? imagePath,
    String? fileUrl,
    String? filePath,
    Duration? position,
    Duration? duration,
    DateTime? createdAt,
    List<String>? contributors,
    String? lyrics,
  }) {
    return ApbUrlPlayableAudio(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      playlistId: playlistId ?? this.playlistId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      imagePath: imagePath ?? this.imagePath,
      fileUrl: fileUrl ?? this.fileUrl,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      createdAt: createdAt ?? this.createdAt,
      contributors: contributors ?? this.contributors,
      lyrics: lyrics ?? this.lyrics,
    );
  }
}

@JsonSerializable(includeIfNull: true)
class ApbFilePlayableAudio extends ApbPlayableAudio {
  ApbFilePlayableAudio({
    required super.id,
    super.sourceId,
    required super.name,
    required super.filePath,
    super.imageUrl,
    super.imagePath,
    super.position,
    super.duration,
    super.contributors,
    super.playlistId,
    super.createdAt,
    super.lyrics,
  }) : super(fileUrl: null, fileType: ApbPlayableFileType.file);

  @override
  AudioSource get audioSource {
    return AudioSource.file('${AudioPlayerBase().saveDirectory}/${filePath!}', tag: tag);
  }

  @override
  factory ApbFilePlayableAudio.fromJson(Map<String, dynamic> json) =>
      _$ApbFilePlayableAudioFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ApbFilePlayableAudioToJson(this);

  @override
  ApbPlayableAudio copyWith({
    String? id,
    String? sourceId,
    String? playlistId,
    String? name,
    String? imageUrl,
    String? imagePath,
    String? fileUrl,
    String? filePath,
    Duration? position,
    Duration? duration,
    DateTime? createdAt,
    List<String>? contributors,
    String? lyrics,
  }) {
    return ApbFilePlayableAudio(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      playlistId: playlistId ?? this.playlistId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      imagePath: imagePath ?? this.imagePath,
      filePath: filePath ?? this.filePath,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      createdAt: createdAt ?? this.createdAt,
      contributors: contributors ?? this.contributors,
      lyrics: lyrics ?? this.lyrics,
    );
  }
}

@JsonSerializable(includeIfNull: true)
class ApbAssetPlayableAudio extends ApbPlayableAudio {
  ApbAssetPlayableAudio({
    required super.id,
    super.sourceId,
    required super.name,
    required this.assetStr,
    super.imageUrl,
    super.imagePath,
    super.duration,
    super.position,
    super.contributors,
    super.playlistId,
    super.createdAt,
    super.lyrics,
  }) : super(
         fileUrl: null,
         filePath: null,
         fileType: ApbPlayableFileType.asset,
       );

  @override
  AudioSource get audioSource {
    return AudioSource.asset(assetStr, tag: tag);
  }

  final String assetStr;

  @override
  factory ApbAssetPlayableAudio.fromJson(Map<String, dynamic> json) =>
      _$ApbAssetPlayableAudioFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ApbAssetPlayableAudioToJson(this);

  @override
  ApbPlayableAudio copyWith({
    String? id,
    String? sourceId,
    String? playlistId,
    String? name,
    String? imageUrl,
    String? imagePath,
    String? fileUrl,
    String? filePath,
    Duration? position,
    Duration? duration,
    DateTime? createdAt,
    List<String>? contributors,
    String? lyrics,
  }) {
    return ApbAssetPlayableAudio(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      playlistId: playlistId ?? this.playlistId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      imagePath: imagePath ?? this.imagePath,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      createdAt: createdAt ?? this.createdAt,
      contributors: contributors ?? this.contributors,
      assetStr: '',
      lyrics: lyrics ?? this.lyrics,
    );
  }
}

class ApbPlayablePlaylist {
  final String? id;
  final String? name;
  final String? imageUrl;
  final String? imagePath;
  final String? desc;
  final List<String>? contributors;
  final bool? shouldHide;
  final List<ApbPlayableAudio>? audios;
  final DateTime? lastUpdated;
  final DateTime? lastPlayed;

  ApbPlayablePlaylist({
    this.shouldHide,
    this.audios,
    this.lastUpdated,
    this.lastPlayed,
    this.id,
    this.name,
    this.imageUrl,
    this.imagePath,
    this.desc,
    this.contributors,
  });

  int get count => audios?.length ?? 0;

  Duration get duration => audios?.fold(Duration.zero, (previousValue, element)
  => Duration(seconds: (previousValue?.inSeconds??0) + (element.duration?.inSeconds ?? 0))) ?? Duration.zero;

  DateTime get lastActive =>
      (lastPlayed ?? DateTime(2000)).millisecondsSinceEpoch <
              _lastUpdated.millisecondsSinceEpoch
          ? _lastUpdated
          : lastPlayed!;

  DateTime get _lastUpdated => lastUpdated!;

  String? get contributorsToString => contributors?.join(', ');
  ApbPlayablePlaylist copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? imagePath,
    String? desc,
    List<String>? contributors,
    bool? shouldHide,
    List<ApbPlayableAudio>? audios,
    DateTime? lastUpdated,
    DateTime? lastPlayed,
  }) {
    return ApbPlayablePlaylist(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      imagePath: imagePath ?? this.imagePath,
      desc: desc ?? this.desc,
      contributors: contributors ?? this.contributors,
      shouldHide: shouldHide ?? this.shouldHide,
      audios: audios ?? this.audios,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      lastPlayed: lastPlayed ?? this.lastPlayed,
    );
  }
}


@JsonSerializable(includeIfNull: true)
class ApbYtPlayableAudio extends ApbPlayableAudio {
  ApbYtPlayableAudio({
    super.id,
    required super.name,
    required this.ytId,
    super.imageUrl,
    super.imagePath,
    super.position,
    super.duration,
    super.createdAt,
    super.contributors,
    super.playlistId
  }) : super(fileType: ApbPlayableFileType.yt, sourceId: ytId);
  final String ytId;
  @override
  AudioSource get audioSource {
    return GetIt.I<ApbYtExplodeProvider>().getYtAudioSource(ytId, tag);
  }

  @override
  Map<String, dynamic> toJson() => _$ApbYtPlayableAudioToJson(this);

  @override
  factory ApbYtPlayableAudio.fromJson(Map<String, dynamic> json) =>
      _$ApbYtPlayableAudioFromJson(json);

  @override
  ApbPlayableAudio copyWith({
    String? id,
    String? sourceId,
    String? playlistId,
    String? name,
    String? imageUrl,
    String? imagePath,
    String? fileUrl,
    String? filePath,
    Duration? position,
    Duration? duration,
    DateTime? createdAt,
    List<String>? contributors,
    String? lyrics,
  }) {
    return ApbYtPlayableAudio(
        id: id ?? this.id,
        name: name ?? this.name,
        imageUrl: imageUrl ?? this.imageUrl,
        imagePath: imagePath ?? this.imagePath,
        position: position ?? this.position,
        duration: duration ?? this.duration,
        createdAt: createdAt ?? this.createdAt,
        contributors: contributors ?? this.contributors,
        playlistId: playlistId ?? this.playlistId, ytId: sourceId ?? ytId
    );
  }

}