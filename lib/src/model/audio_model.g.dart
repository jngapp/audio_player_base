// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApbUrlPlayableAudio _$ApbUrlPlayableAudioFromJson(Map<String, dynamic> json) =>
    ApbUrlPlayableAudio(
      id: json['id'] as String?,
      sourceId: json['sourceId'] as String?,
      name: json['name'] as String?,
      fileUrl: json['fileUrl'] as String?,
      imageUrl: json['imageUrl'] as String?,
      imagePath: json['imagePath'] as String?,
      position:
          json['position'] == null
              ? null
              : Duration(microseconds: (json['position'] as num).toInt()),
      duration:
          json['duration'] == null
              ? null
              : Duration(microseconds: (json['duration'] as num).toInt()),
      contributors:
          (json['contributors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      playlistId: json['playlistId'] as String?,
      createdAt:
          json['createdAt'] == null
              ? null
              : DateTime.parse(json['createdAt'] as String),
      lyrics: json['lyrics'] as String?,
    );

Map<String, dynamic> _$ApbUrlPlayableAudioToJson(
  ApbUrlPlayableAudio instance,
) => <String, dynamic>{
  'id': instance.id,
  'sourceId': instance.sourceId,
  'playlistId': instance.playlistId,
  'name': instance.name,
  'imageUrl': instance.imageUrl,
  'imagePath': instance.imagePath,
  'fileUrl': instance.fileUrl,
  'position': instance.position?.inMicroseconds,
  'duration': instance.duration?.inMicroseconds,
  'createdAt': instance.createdAt?.toIso8601String(),
  'contributors': instance.contributors,
  'lyrics': instance.lyrics,
};

ApbFilePlayableAudio _$ApbFilePlayableAudioFromJson(
  Map<String, dynamic> json,
) => ApbFilePlayableAudio(
  id: json['id'] as String?,
  sourceId: json['sourceId'] as String?,
  name: json['name'] as String?,
  filePath: json['filePath'] as String?,
  imageUrl: json['imageUrl'] as String?,
  imagePath: json['imagePath'] as String?,
  position:
      json['position'] == null
          ? null
          : Duration(microseconds: (json['position'] as num).toInt()),
  duration:
      json['duration'] == null
          ? null
          : Duration(microseconds: (json['duration'] as num).toInt()),
  contributors:
      (json['contributors'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
  playlistId: json['playlistId'] as String?,
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  lyrics: json['lyrics'] as String?,
);

Map<String, dynamic> _$ApbFilePlayableAudioToJson(
  ApbFilePlayableAudio instance,
) => <String, dynamic>{
  'id': instance.id,
  'sourceId': instance.sourceId,
  'playlistId': instance.playlistId,
  'name': instance.name,
  'imageUrl': instance.imageUrl,
  'imagePath': instance.imagePath,
  'filePath': instance.filePath,
  'position': instance.position?.inMicroseconds,
  'duration': instance.duration?.inMicroseconds,
  'createdAt': instance.createdAt?.toIso8601String(),
  'contributors': instance.contributors,
  'lyrics': instance.lyrics,
};

ApbAssetPlayableAudio _$ApbAssetPlayableAudioFromJson(
  Map<String, dynamic> json,
) => ApbAssetPlayableAudio(
  id: json['id'] as String?,
  sourceId: json['sourceId'] as String?,
  name: json['name'] as String?,
  assetStr: json['assetStr'] as String,
  imageUrl: json['imageUrl'] as String?,
  imagePath: json['imagePath'] as String?,
  duration:
      json['duration'] == null
          ? null
          : Duration(microseconds: (json['duration'] as num).toInt()),
  position:
      json['position'] == null
          ? null
          : Duration(microseconds: (json['position'] as num).toInt()),
  contributors:
      (json['contributors'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
  playlistId: json['playlistId'] as String?,
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  lyrics: json['lyrics'] as String?,
);

Map<String, dynamic> _$ApbAssetPlayableAudioToJson(
  ApbAssetPlayableAudio instance,
) => <String, dynamic>{
  'id': instance.id,
  'sourceId': instance.sourceId,
  'playlistId': instance.playlistId,
  'name': instance.name,
  'imageUrl': instance.imageUrl,
  'imagePath': instance.imagePath,
  'position': instance.position?.inMicroseconds,
  'duration': instance.duration?.inMicroseconds,
  'createdAt': instance.createdAt?.toIso8601String(),
  'contributors': instance.contributors,
  'lyrics': instance.lyrics,
  'assetStr': instance.assetStr,
};

ApbYtPlayableAudio _$ApbYtPlayableAudioFromJson(Map<String, dynamic> json) =>
    ApbYtPlayableAudio(
      id: json['id'] as String?,
      name: json['name'] as String?,
      ytId: json['ytId'] as String,
      imageUrl: json['imageUrl'] as String?,
      imagePath: json['imagePath'] as String?,
      position:
          json['position'] == null
              ? null
              : Duration(microseconds: (json['position'] as num).toInt()),
      duration:
          json['duration'] == null
              ? null
              : Duration(microseconds: (json['duration'] as num).toInt()),
      createdAt:
          json['createdAt'] == null
              ? null
              : DateTime.parse(json['createdAt'] as String),
      contributors:
          (json['contributors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      playlistId: json['playlistId'] as String?,
    );

Map<String, dynamic> _$ApbYtPlayableAudioToJson(ApbYtPlayableAudio instance) =>
    <String, dynamic>{
      'id': instance.id,
      'playlistId': instance.playlistId,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'imagePath': instance.imagePath,
      'position': instance.position?.inMicroseconds,
      'duration': instance.duration?.inMicroseconds,
      'createdAt': instance.createdAt?.toIso8601String(),
      'contributors': instance.contributors,
      'ytId': instance.ytId,
    };
