import 'package:equatable/equatable.dart';
import '../../domain/entities/onboarding_item.dart';

class OnboardingItemModel extends Equatable {
  final String title;
  final String description;
  final String imageAsset;

  const OnboardingItemModel({
    required this.title,
    required this.description,
    required this.imageAsset,
  });

  factory OnboardingItemModel.fromJson(Map<String, dynamic> json) {
    return OnboardingItemModel(
      title: json['title'] as String,
      description: json['description'] as String,
      imageAsset: json['imageAsset'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageAsset': imageAsset,
    };
  }

  OnboardingItem toEntity() {
    return OnboardingItem(
      title: title,
      description: description,
      imageAsset: imageAsset,
    );
  }

  @override
  List<Object?> get props => [title, description, imageAsset];
}
