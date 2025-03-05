import 'package:flutter_learning/domain/entities/story_entity.dart';

/// Story model represents the data structure for a story
/// This is part of the data layer and maps to the StoryEntity in the domain layer
class StoryModel extends StoryEntity {
  const StoryModel({
    required String id,
    required String title,
    required String thumbnailUrl,
    bool isFavorite = false,
    String? description,
    String? content,
    DateTime? lastReadAt,
  }) : super(
          id: id,
          title: title,
          thumbnailUrl: thumbnailUrl,
          isFavorite: isFavorite,
          description: description,
          content: content,
          lastReadAt: lastReadAt,
        );

  /// Create a StoryModel from a JSON map
  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'],
      title: json['title'],
      thumbnailUrl: json['thumbnail_url'],
      isFavorite: json['is_favorite'] ?? false,
      description: json['description'],
      content: json['content'],
      lastReadAt: json['last_read_at'] != null
          ? DateTime.parse(json['last_read_at'])
          : null,
    );
  }

  /// Convert this StoryModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumbnail_url': thumbnailUrl,
      'is_favorite': isFavorite,
      'description': description,
      'content': content,
      'last_read_at': lastReadAt?.toIso8601String(),
    };
  }

  /// Create a StoryModel from a StoryEntity
  factory StoryModel.fromEntity(StoryEntity entity) {
    return StoryModel(
      id: entity.id,
      title: entity.title,
      thumbnailUrl: entity.thumbnailUrl,
      isFavorite: entity.isFavorite,
      description: entity.description,
      content: entity.content,
      lastReadAt: entity.lastReadAt,
    );
  }
}