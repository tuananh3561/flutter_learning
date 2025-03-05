import 'package:equatable/equatable.dart';

/// Story entity represents a story in the application
/// This is a core business object in the domain layer
class StoryEntity extends Equatable {
  final String id;
  final String title;
  final String thumbnailUrl;
  final bool isFavorite;
  final String? description;
  final String? content;
  final DateTime? lastReadAt;
  
  const StoryEntity({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    this.isFavorite = false,
    this.description,
    this.content,
    this.lastReadAt,
  });
  
  @override
  List<Object?> get props => [
    id, 
    title, 
    thumbnailUrl, 
    isFavorite,
    description,
    content,
    lastReadAt,
  ];
  
  /// Create a copy of this StoryEntity with the given fields replaced
  StoryEntity copyWith({
    String? id,
    String? title,
    String? thumbnailUrl,
    bool? isFavorite,
    String? description,
    String? content,
    DateTime? lastReadAt,
  }) {
    return StoryEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      description: description ?? this.description,
      content: content ?? this.content,
      lastReadAt: lastReadAt ?? this.lastReadAt,
    );
  }
}