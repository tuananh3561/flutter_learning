import 'dart:convert';

/// Model class for the root.json file in a story
class StoryRootModel {
  final String fontName;
  final IllustratorInfo illustratedBy;
  final TitleInfo title;
  final List<SyncData> syncData;
  final String titleText;
  final double versionStory;
  final WriterInfo writtenBy;

  StoryRootModel({
    required this.fontName,
    required this.illustratedBy,
    required this.title,
    required this.syncData,
    required this.titleText,
    required this.versionStory,
    required this.writtenBy,
  });

  factory StoryRootModel.fromJson(Map<String, dynamic> json) {
    return StoryRootModel(
      fontName: json['fontname'] ?? '',
      illustratedBy: IllustratorInfo.fromJson(json['illustratedby'] ?? {}),
      title: TitleInfo.fromJson(json['title'] ?? {}),
      syncData: (json['sync_data'] as List<dynamic>? ?? [])
          .map((e) => SyncData.fromJson(e))
          .toList(),
      titleText: json['title_text'] is String ? json['title_text'] : '',
      versionStory: (json['version_story'] ?? 0.0).toDouble(),
      writtenBy: WriterInfo.fromJson(json['writentby'] ?? {}),
    );
  }

  /// Load a StoryRootModel from a JSON string
  static Future<StoryRootModel> fromJsonString(String jsonString) async {
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return StoryRootModel.fromJson(jsonMap);
  }
}

/// Model for illustrator information
class IllustratorInfo {
  final String audio;
  final double duration;
  final String illustratedBy;

  IllustratorInfo({
    required this.audio,
    required this.duration,
    required this.illustratedBy,
  });

  factory IllustratorInfo.fromJson(Map<String, dynamic> json) {
    return IllustratorInfo(
      audio: json['audio'] ?? '',
      duration: (json['duration'] ?? 0.0).toDouble(),
      illustratedBy: json['illustratedby'] ?? '',
    );
  }
}

/// Model for title information
class TitleInfo {
  final String audio;

  TitleInfo({required this.audio});

  factory TitleInfo.fromJson(Map<String, dynamic> json) {
    return TitleInfo(
      audio: json['audio'] ?? '',
    );
  }
}

/// Model for writer information
class WriterInfo {
  final String audio;
  final double duration;
  final String writtenBy;

  WriterInfo({
    required this.audio,
    required this.duration,
    required this.writtenBy,
  });

  factory WriterInfo.fromJson(Map<String, dynamic> json) {
    return WriterInfo(
      audio: json['audio'] ?? '',
      duration: (json['duration'] ?? 0.0).toDouble(),
      writtenBy: json['writentby'] ?? '',
    );
  }
}

/// Model for synchronization data
class SyncData {
  final int endTime;
  final int startTime;
  final int timeEndFrame;
  final int timeStartFrame;
  final String word;

  SyncData({
    required this.endTime,
    required this.startTime,
    required this.timeEndFrame,
    required this.timeStartFrame,
    required this.word,
  });

  factory SyncData.fromJson(Map<String, dynamic> json) {
    return SyncData(
      endTime: json['e'] ?? 0,
      startTime: json['s'] ?? 0,
      timeEndFrame: json['te'] ?? 0,
      timeStartFrame: json['ts'] ?? 0,
      word: json['w'] ?? '',
    );
  }
}

/// Model class for a story page (4063_1_*.json files)
class StoryPageModel {
  final List<AudioInfo> audio;
  final BackgroundImage bgImage;
  final String boxType;
  final int fontSize;
  final String highlightColor;
  final List<ImageElement> images;
  final int lineHeight;
  final String normalColor;
  final List<TextElement> textElements;

  StoryPageModel({
    required this.audio,
    required this.bgImage,
    required this.boxType,
    required this.fontSize,
    required this.highlightColor,
    required this.images,
    required this.lineHeight,
    required this.normalColor,
    required this.textElements,
  });

  factory StoryPageModel.fromJson(Map<String, dynamic> json) {
    return StoryPageModel(
      audio: (json['audio'] as List<dynamic>? ?? [])
          .map((e) => AudioInfo.fromJson(e))
          .toList(),
      bgImage: BackgroundImage.fromJson(json['bg_img'] ?? {}),
      boxType: json['box_type'] ?? '',
      fontSize: json['fontsize'] ?? 0,
      highlightColor: json['highlight_color'] ?? '',
      images: (json['image'] as List<dynamic>? ?? [])
          .map((e) => ImageElement.fromJson(e))
          .toList(),
      lineHeight: json['line_height'] ?? 0,
      normalColor: json['normal_color'] ?? '',
      textElements: (json['text'] as List<dynamic>? ?? [])
          .map((e) => TextElement.fromJson(e))
          .toList(),
    );
  }

  /// Load a StoryPageModel from a JSON string
  static Future<StoryPageModel> fromJsonString(String jsonString) async {
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return StoryPageModel.fromJson(jsonMap);
  }
}

/// Model for audio information in a story page
class AudioInfo {
  final String path;
  final dynamic pause;
  final int start;
  final List<SyncData> sync;

  AudioInfo({
    required this.path,
    required this.pause,
    required this.start,
    required this.sync,
  });

  factory AudioInfo.fromJson(Map<String, dynamic> json) {
    return AudioInfo(
      path: json['path'] ?? '',
      pause: json['pause'],
      start: json['start'] ?? 0,
      sync: (json['sync'] as List<dynamic>? ?? [])
          .map((e) => SyncData.fromJson(e))
          .toList(),
    );
  }
}

/// Model for background image information
class BackgroundImage {
  final String path;
  final String position;

  BackgroundImage({
    required this.path,
    required this.position,
  });

  factory BackgroundImage.fromJson(Map<String, dynamic> json) {
    return BackgroundImage(
      path: json['path'] ?? '',
      position: json['position'] ?? '',
    );
  }
}

/// Model for image elements in a story page
class ImageElement {
  final int animationOrder;
  final bool animationReset;
  final String animationType;
  final ImageAudio audio;
  final String contentSize;
  final String effect;
  final String path;
  final String position;
  final bool repeatAnimation;
  final dynamic sequence;
  final int starOrder;
  final List<TouchArea> touch;
  final bool touchable;
  final String type;
  final int zOrder;

  ImageElement({
    required this.animationOrder,
    required this.animationReset,
    required this.animationType,
    required this.audio,
    required this.contentSize,
    required this.effect,
    required this.path,
    required this.position,
    required this.repeatAnimation,
    required this.sequence,
    required this.starOrder,
    required this.touch,
    required this.touchable,
    required this.type,
    required this.zOrder,
  });

  factory ImageElement.fromJson(Map<String, dynamic> json) {
    return ImageElement(
      animationOrder: json['animation_order'] ?? 0,
      animationReset: json['animation_reset'] ?? false,
      animationType: json['animation_type'] ?? '',
      audio: ImageAudio.fromJson(json['audio'] ?? {}),
      contentSize: json['contentsize'] ?? '',
      effect: json['effect'] ?? '',
      path: json['path'] ?? '',
      position: json['position'] ?? '',
      repeatAnimation: json['repeat_animation'] ?? false,
      sequence: json['sequence'],
      starOrder: json['star_order'] ?? 0,
      touch: json['touch'] is List
          ? (json['touch'] as List<dynamic>)
              .map((e) => TouchArea.fromJson(e))
              .toList()
          : [],
      touchable: json['touchable'] ?? false,
      type: json['type'] ?? '',
      zOrder: json['z_order'] ?? 0,
    );
  }
}

/// Model for audio associated with an image
class ImageAudio {
  final int duration;
  final String path;
  final String text;
  final int wText;

  ImageAudio({
    required this.duration,
    required this.path,
    required this.text,
    required this.wText,
  });

  factory ImageAudio.fromJson(Map<String, dynamic> json) {
    return ImageAudio(
      duration: json['duration'] ?? 0,
      path: json['path'] ?? '',
      text: json['text'] ?? '',
      wText: json['w_text'] ?? 0,
    );
  }
}

/// Model for touch areas in an image
class TouchArea {
  final String boundingBox;
  final String starPosition;
  final List<String>? vertices;

  TouchArea({
    required this.boundingBox,
    required this.starPosition,
    this.vertices,
  });

  factory TouchArea.fromJson(Map<String, dynamic> json) {
    return TouchArea(
      boundingBox: json['boundingbox'] ?? '',
      starPosition: json['star_position'] ?? '',
      vertices: json['vertices'] is List
          ? (json['vertices'] as List<dynamic>).cast<String>()
          : null,
    );
  }
}

/// Model for text elements in a story page
class TextElement {
  final String boundingBox;
  final List<dynamic>? configAudio;
  final List<dynamic>? configImage;
  final dynamic end;
  final dynamic start;
  final String text;

  TextElement({
    required this.boundingBox,
    this.configAudio,
    this.configImage,
    this.end,
    this.start,
    required this.text,
  });

  factory TextElement.fromJson(Map<String, dynamic> json) {
    return TextElement(
      boundingBox: json['boundingbox'] ?? '',
      configAudio: json['config_audio'],
      configImage: json['config_image'],
      end: json['end'],
      start: json['start'],
      text: json['text'] ?? '',
    );
  }
}
