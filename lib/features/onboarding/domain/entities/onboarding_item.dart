import 'package:equatable/equatable.dart';

class OnboardingItem extends Equatable {
  final String title;
  final String description;
  final String imageAsset;

  const OnboardingItem({
    required this.title,
    required this.description,
    required this.imageAsset,
  });

  @override
  List<Object?> get props => [title, description, imageAsset];
}
